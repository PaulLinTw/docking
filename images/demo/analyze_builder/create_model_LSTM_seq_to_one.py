# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 18:17:12 2018

@author: jimmybow
"""

from mydf import *
from sklearn.feature_extraction import DictVectorizer
from pymongo import MongoClient
from datetime import datetime, timedelta
import pytz
import sys
from usecase_incl import incl
import torch
import torch.nn as nn
from torch.autograd import Variable
import torch.utils.data as Data
import pickle
import redis
#sys.exit()

rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
GMT = pytz.timezone('GMT')
print(datetime.now(GMT), 'create_model 開始 !', file = open('log.txt', 'a'))
init_time = datetime(2018,3,27,8,0,0, tzinfo = GMT)
now = int((datetime.now(GMT)-init_time).total_seconds()/60)

client = MongoClient(incl.mongo_connector)
db = client.demo
coll = db.minutes

data_range = int(sys.argv[1])
#data_range = 60
time_range = [init_time + timedelta(minutes = now-6 - data_range + 1),
              init_time + timedelta(minutes = now-6 )  ]
query = coll.find({'minute': {'$gte': now - 6  - data_range + 1,
                                     '$lte': now - 6   }})

df = pd.DataFrame([i for i in query])
df >>= drop('_id')
df_mean = pickle.loads(rds.get('df_mean'))
df = pd.concat([df_mean  >> left_join(df[df.minute==i]) >> mutate(minute=i) for i in range(now-1 - data_range + 1, now)]).reset_index(drop = True)
ww = df['count'].isnull()
df['count'][ww] = df['mean'][ww]
df >>= drop('mean')

time_step = 10

df_country = (df 
 >> rename(action_type = 'action', counts = 'count') 
 >> group_by('country', 'product', 'action_type', 'minute') 
 >> summarize(counts = X.counts.sum())
 >> group_by('country', 'product', 'action_type')
 >> mutate(**{'counts_t-%02.f'%i : X.counts.shift(i) for i in range(1,time_step+1)})
 >> r(X.dropna())
)

df >>= (rename(action_type = 'action', counts = 'count')
 >> arrange('minute') 
 >> group_by('country', 'product', 'site', 'action_type') 
 >> mutate(**{'counts_t-%02.f'%i : X.counts.shift(i) for i in range(1,time_step+1)})
 >> r(X.dropna())
)


#########################################################################################################
######## 以下是為了正式使用 (採用所有至目前時間點的資料進行模型訓練) #################################
########################################### MLP #######################################################
df_feature = df >> select('site', 'product', 'country', 'action_type', 'counts_t-01')
vec = DictVectorizer(sparse=False)
data_feature = vec.fit_transform(df_feature.to_dict('records'))
counts_index = int(where(pd.Series(vec.get_feature_names()) == 'counts_t-01'))

df_x = df.iloc[:,6:] 
df_x = df_x[df_x.columns.sort_values(ascending=False)]
df_y = df >> select('counts')
data_x = df_x.as_matrix().reshape(df_x.shape[0], df_x.shape[1], 1)
data_y = df_y.as_matrix().reshape(df_y.shape[0], df_y.shape[1], 1)
data_feature = data_feature.reshape(data_feature.shape[0], 1, data_feature.shape[1])
data_feature = np.concatenate([data_feature for i in range(10)],axis = 1)
data_feature[:,:,counts_index] = data_x[:,:,0] 

train_x = torch.from_numpy(data_feature).float()
train_y = torch.from_numpy(data_y).float()

#  rds.set('LSTM_s1_EPOCH', 25)
#  rds.set('LSTM_s1_BATCH', 50)
#  rds.set('LSTM_s1_LR', 0.001)
EPOCH = int(rds.get('LSTM_s1_EPOCH'))        
BATCH_SIZE = int(rds.get('LSTM_s1_BATCH'))   
LR = float(rds.get('LSTM_s1_LR'))       

# dataset
class train_Dataset(Data.Dataset): # 需要继承 data.Dataset
    def __init__(self):
        self.train_x = train_x
        self.train_y = train_y
    def __getitem__(self, index):
        data = (self.train_x[index], self.train_y[index])
        return data
    def __len__(self):
        return len(self.train_y)

class lstm_reg_seq_to_one(nn.Module):
    def __init__(self, input_size=66, hidden_size=30, output_size=1, num_layers=2):
        super(lstm_reg_seq_to_one, self).__init__()
        
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)  
        self.reg = nn.Linear(hidden_size, output_size) 
        
    def forward(self, x):
        x, (h_n, c_n) = self.lstm(x) 
        # LSTM 輸入資料的格式 (sample size, seq_len, input_size) = (mini_batch, 10, 66)
        # LSTM 輸出的格式 (sample size, seq_len, hidden_size * num_directions) = (mini_batch, 10, 30)
        x = x[:, -1, :]    # 取出序列的最後一個時間步的值   (mini_batch, 30)
        x = self.reg(x)  # (mini_batch, 1)
        return x

net = lstm_reg_seq_to_one(train_x.shape[2]) 
data_start_time = time_range[0]
if rds.get('prediction_LSTM_s1') is not None:
    para = pickle.loads(rds.get('prediction_LSTM_s1'))
    net.load_state_dict(para)
    data_start_time = pickle.loads(rds.get('prediction_LSTM_s1_start_time'))
    
# 建模
train_loader = Data.DataLoader(dataset = train_Dataset(), batch_size = BATCH_SIZE, shuffle = True)

optimizer = torch.optim.Adam(net.parameters(), lr=LR)   # optimize all cnn parameters
loss_func = nn.MSELoss()   

print(datetime.now(GMT), 'LSTM 訓練開始 !', file = open('log.txt', 'a'))
print(datetime.now(GMT), 'LSTM 訓練開始 !')
for epoch in range(EPOCH):
    for step, (x, y) in enumerate(train_loader, 1):   # 分配 batch data, normalize x when iterate train_loader
        b_x = Variable(x)   # batch x
        b_y = Variable(y)   # batch y

        out = net(b_x)               #  (mini_batch, 1)
        loss = loss_func(out, b_y[:,0,:])     # MSE loss
        optimizer.zero_grad()           # clear gradients for this training step
        loss.backward()                 # backpropagation, compute gradients
        optimizer.step()                # apply gradients
        
        #if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0], file = open('log.txt', 'a'))
        if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0])

rds.set('prediction_LSTM_s1', pickle.dumps(net.state_dict()))
rds.set('prediction_vec_LSTM_s1', pickle.dumps(vec))
rds.set('prediction_LSTM_s1_start_time', pickle.dumps(data_start_time))
rds.set('prediction_LSTM_s1_range', 'training data from [{}] to [{}]'.format(data_start_time, time_range[1]))

#########################################################################################################
######## 以下是為了正式使用 (採用所有至目前時間點的資料進行模型訓練) #################################
########################################### MLP_country #######################################################
df_feature = df_country >> select('action_type', 'product', 'country', 'counts_t-01')
vec_country = DictVectorizer(sparse=False)
data_feature = vec_country.fit_transform(df_feature.to_dict('records'))
counts_index = int(where(pd.Series(vec_country.get_feature_names()) == 'counts_t-01'))

df_x = df_country.iloc[:,5:] 
df_x = df_x[df_x.columns.sort_values(ascending=False)]
df_y = df_country >> select('counts')
data_x = df_x.as_matrix().reshape(df_x.shape[0], df_x.shape[1], 1)
data_y = df_y.as_matrix().reshape(df_y.shape[0], df_y.shape[1], 1)
data_feature = data_feature.reshape(data_feature.shape[0], 1, data_feature.shape[1])
data_feature = np.concatenate([data_feature for i in range(10)],axis = 1)
data_feature[:,:,counts_index] = data_x[:,:,0] 

train_x = torch.from_numpy(data_feature).float()
train_y = torch.from_numpy(data_y).float()

net = lstm_reg_seq_to_one(train_x.shape[2])    
data_start_time = time_range[0]
if rds.get('prediction_LSTM_s1_country') is not None:
    para = pickle.loads(rds.get('prediction_LSTM_s1_country'))
    net.load_state_dict(para)
    data_start_time = pickle.loads(rds.get('prediction_LSTM_s1_start_time'))
    
#  rds.set('LSTM_s1_country_EPOCH', 50)
#  rds.set('LSTM_s1_country_BATCH', 40)
#  rds.set('LSTM_s1_country_LR', 0.001)
EPOCH = int(rds.get('LSTM_s1_country_EPOCH'))        
BATCH_SIZE = int(rds.get('LSTM_s1_country_BATCH'))   
LR = float(rds.get('LSTM_s1_country_LR'))         
    
# 建模
train_loader = Data.DataLoader(dataset = train_Dataset(), batch_size = BATCH_SIZE, shuffle = True)

optimizer = torch.optim.Adam(net.parameters(), lr=LR)   # optimize all cnn parameters
loss_func = nn.MSELoss()   

print(datetime.now(GMT), 'LSTM_s1_country 訓練開始 !', file = open('log.txt', 'a'))
print(datetime.now(GMT), 'LSTM_s1_country 訓練開始 !')
for epoch in range(EPOCH):
    for step, (x, y) in enumerate(train_loader, 1):   # 分配 batch data, normalize x when iterate train_loader
        b_x = Variable(x)   # batch x
        b_y = Variable(y)   # batch y

        out = net(b_x)               # (mini_batch, 1)
        loss = loss_func(out, b_y[:,0,:])     # MSE loss
        optimizer.zero_grad()           # clear gradients for this training step
        loss.backward()                 # backpropagation, compute gradients
        optimizer.step()                # apply gradients
        
        #if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0], file = open('log.txt', 'a'))
        if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0])

rds.set('prediction_LSTM_s1_country', pickle.dumps(net.state_dict()))
rds.set('prediction_vec_country_LSTM_s1', pickle.dumps(vec_country))
rds.set('prediction_LSTM_s1_start_time', pickle.dumps(data_start_time))
rds.set('prediction_LSTM_s1_range', 'training data from [{}] to [{}]'.format(data_start_time, time_range[1]))

print(datetime.now(GMT), 'create_model_LSTM_s1 完成 !', file = open('log.txt', 'a'))
