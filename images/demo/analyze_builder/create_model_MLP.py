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

df_country = (df 
 >> rename(action_type = 'action', counts = 'count') 
 >> group_by('country', 'product', 'action_type', 'minute') 
 >> summarize(counts = X.counts.sum())
 >> group_by('country', 'product', 'action_type')
 >> mutate(
        **{'counts_t-1': X.counts.shift(1),
           'counts_t-2': X.counts.shift(2),
           'counts_t-3': X.counts.shift(3),
           'counts_t-4': X.counts.shift(4),
           'counts_t-5': X.counts.shift(5)} )
 >> r(X.dropna())
)

df >>= (rename(action_type = 'action', counts = 'count')
 >> arrange('minute') 
 >> group_by('country', 'product', 'site', 'action_type') >> mutate(
        **{'counts_t-1': X.counts.shift(1),
           'counts_t-2': X.counts.shift(2),
           'counts_t-3': X.counts.shift(3),
           'counts_t-4': X.counts.shift(4),
           'counts_t-5': X.counts.shift(5)} )
 >> r(X.dropna())
)


#########################################################################################################
######## 以下是為了正式使用 (採用所有至目前時間點的資料進行模型訓練) #################################
########################################### MLP #######################################################
train_y = df.counts.as_matrix()
ddd = df >> drop('minute', 'counts')

vec = DictVectorizer(sparse=False)
train_x = vec.fit_transform(ddd.to_dict('records'))
# vec.get_feature_names()

EPOCH = int(rds.get('MLP_EPOCH'))         # 50
BATCH_SIZE = int(rds.get('MLP_BATCH'))   # 50
LR = float(rds.get('MLP_LR'))         # 0.001

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

class MLP(nn.Module):
    def __init__(self, n_input):
        super(MLP, self).__init__()
        self.layer1 = nn.Sequential( 
            nn.Linear(n_input, 50),  
            nn.BatchNorm1d(50),
            nn.ReLU()
        )
        
        self.layer2 = nn.Sequential( 
            nn.Linear(50, 50),  
            nn.BatchNorm1d(50),
            nn.ReLU()
        )
        
        self.layer3 = nn.Sequential( 
            nn.Linear(50, 30),  
            nn.BatchNorm1d(30),
            nn.ReLU()
        )
        
        self.out = nn.Linear(30, 1)
        
    def forward(self, x):
        x = self.layer1(x)
        x = self.layer2(x)
        x = self.layer3(x)
        out = self.out(x)
        return out

mlp = MLP(train_x.shape[1])    
data_start_time = time_range[0]
if rds.get('prediction_mlp') is not None:
    para = pickle.loads(rds.get('prediction_mlp'))
    mlp.load_state_dict(para)
    data_start_time = pickle.loads(rds.get('prediction_mlp_start_time'))
    
# 建模
train_loader = Data.DataLoader(dataset = train_Dataset(), batch_size = BATCH_SIZE, shuffle = True)

optimizer = torch.optim.Adam(mlp.parameters(), lr=LR)   # optimize all cnn parameters
loss_func = nn.MSELoss()   

print(datetime.now(GMT), 'mlp 訓練開始 !', file = open('log.txt', 'a'))
print(datetime.now(GMT), 'mlp 訓練開始 !')
for epoch in range(EPOCH):
    for step, (x, y) in enumerate(train_loader, 1):   # 分配 batch data, normalize x when iterate train_loader
        b_x = Variable(x.float())   # batch x
        b_y = Variable(y.float())   # batch y

        output = mlp(b_x)               # mlp output, 每筆資料預估是 0-9 的期望值 (50, 10) 
        loss = loss_func(output, b_y)   # MSE loss
        optimizer.zero_grad()           # clear gradients for this training step
        loss.backward()                 # backpropagation, compute gradients
        optimizer.step()                # apply gradients
        
        #if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0], file = open('log.txt', 'a'))
        if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0])

rds.set('prediction_mlp', pickle.dumps(mlp.state_dict()))
rds.set('prediction_vec', pickle.dumps(vec))
rds.set('prediction_mlp_start_time', pickle.dumps(data_start_time))
rds.set('prediction_mlp_range', 'training data from [{}] to [{}]'.format(data_start_time, time_range[1]))

#########################################################################################################
######## 以下是為了正式使用 (採用所有至目前時間點的資料進行模型訓練) #################################
########################################### MLP_country #######################################################
train_y = df_country.counts.as_matrix()
ddd = df_country  >> drop('minute', 'counts')

vec_country = DictVectorizer(sparse=False)
train_x = vec_country.fit_transform(ddd.to_dict('records'))
# vec_country.get_feature_names()

mlp = MLP(train_x.shape[1])    
data_start_time = time_range[0]
if rds.get('prediction_mlp_country') is not None:
    para = pickle.loads(rds.get('prediction_mlp_country'))
    mlp.load_state_dict(para)
    data_start_time = pickle.loads(rds.get('prediction_mlp_start_time'))
    
# 建模
train_loader = Data.DataLoader(dataset = train_Dataset(), batch_size = BATCH_SIZE, shuffle = True)

optimizer = torch.optim.Adam(mlp.parameters(), lr=LR)   # optimize all cnn parameters
loss_func = nn.MSELoss()   

print(datetime.now(GMT), 'mlp_country 訓練開始 !', file = open('log.txt', 'a'))
print(datetime.now(GMT), 'mlp_country 訓練開始 !')
for epoch in range(EPOCH):
    for step, (x, y) in enumerate(train_loader, 1):   # 分配 batch data, normalize x when iterate train_loader
        b_x = Variable(x.float())   # batch x
        b_y = Variable(y.float())   # batch y

        output = mlp(b_x)               # mlp output, 每筆資料預估是 0-9 的期望值 (50, 10) 
        loss = loss_func(output, b_y)   # MSE loss
        optimizer.zero_grad()           # clear gradients for this training step
        loss.backward()                 # backpropagation, compute gradients
        optimizer.step()                # apply gradients
        
        #if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss:', '%.10f' % loss.data[0], file = open('log.txt', 'a')) 
        if step % 100 == 0: print('Epoch', epoch, 'Step', step, 'Train loss :', '%.10f' % loss.data[0])

rds.set('prediction_mlp_country', pickle.dumps(mlp.state_dict()))
rds.set('prediction_vec_country', pickle.dumps(vec_country))
rds.set('prediction_mlp_start_time', pickle.dumps(data_start_time))
rds.set('prediction_mlp_range', 'training data from [{}] to [{}]'.format(data_start_time, time_range[1]))

print(datetime.now(GMT), 'create_model_MLP 完成 !', file = open('log.txt', 'a'))
