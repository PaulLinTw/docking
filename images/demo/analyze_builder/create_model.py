# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 18:17:12 2018

@author: jimmybow
"""

from mydf import *
from sklearn import datasets, metrics
from sklearn import tree 
from sklearn.feature_extraction import DictVectorizer
from pymongo import MongoClient
from datetime import datetime, timedelta
import pytz
import sys
from usecase_incl import incl
import pickle
import redis
import gridfs
from bson.objectid import ObjectId
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
#data_range = 40
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


###################################
######## 以下是為了正式使用 (採用所有至目前時間點的資料進行模型訓練) ########
######## tree ########
train_y = df.counts
ddd = df >> drop('minute', 'counts')

vec = DictVectorizer(sparse=False)
train_x = vec.fit_transform(ddd.to_dict('records'))
vec.get_feature_names()

# 決策樹 建模
Tree = tree.DecisionTreeRegressor().fit(train_x, train_y)

db = client['model']
fs = gridfs.GridFS(db)
get_key = rds.get('prediction_key').decode()
put_key = fs.put(pickle.dumps(Tree))
#rds.set('prediction_tree', pickle.dumps(Tree))
rds.set('prediction_key', put_key)
rds.set('prediction_vec', pickle.dumps(vec))
rds.set('prediction_tree_range', 'training data from [{}] to [{}]'.format(time_range[0], time_range[1]))
try: fs.delete(ObjectId(get_key)) 
except: pass
######## tree country ########
train_y = df_country.counts
ddd = df_country  >> drop('minute', 'counts')

vec_country = DictVectorizer(sparse=False)
train_x = vec_country.fit_transform(ddd.to_dict('records'))
vec_country.get_feature_names()

# 決策樹 建模
Tree_country = tree.DecisionTreeRegressor().fit(train_x, train_y)

get_key = rds.get('prediction_key_country').decode()
put_key = fs.put(pickle.dumps(Tree_country))
#rds.set('prediction_tree_country', pickle.dumps(Tree_country))
rds.set('prediction_key_country', put_key)
rds.set('prediction_vec_country', pickle.dumps(vec_country))
rds.set('prediction_tree_range', 'training data from [{}] to [{}]'.format(time_range[0], time_range[1]))
try: fs.delete(ObjectId(get_key)) 
except: pass
print(datetime.now(GMT), 'create_model 完成 !', file = open('log.txt', 'a'))

#from sklearn.externals import joblib
#joblib.dump(Tree, 'Tree')
#LR = joblib.load('Tree')

