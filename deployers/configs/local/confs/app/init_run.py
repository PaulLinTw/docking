from mydf import *
from sklearn.feature_extraction import DictVectorizer
from pymongo import MongoClient
from datetime import datetime, timedelta
import pytz
import sys
from usecase_incl import incl
import pickle
import redis

rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
GMT = pytz.timezone('GMT')
print(datetime.now(GMT), 'create_model 開始 !', file = open('log.txt', 'a'))
init_time = datetime(2018,3,27,8,0,0, tzinfo = GMT)
now = int((datetime.now(GMT)-init_time).total_seconds()/60)

client = MongoClient(incl.mongo_connector)
db = client.demo
coll = db.minutes

data_range = 60
time_range = [init_time + timedelta(minutes = now-6 - data_range + 1),
              init_time + timedelta(minutes = now-6 )  ]
query = coll.find({'minute': {'$gte': now - 6  - data_range + 1,
                                     '$lte': now - 6   }})

df = pd.DataFrame([i for i in query])
df_mean = df >> group_by('country', 'product', 'action', 'site') >> summarize(mean = X['count'].mean())
df_mean['mean']=df_mean['mean'].astype(int)
rds.set('df_mean', pickle.dumps(df_mean))

rds.set('MLP_EPOCH', 50)
rds.set('MLP_BATCH', 50)
rds.set('MLP_LR', 0.001)
rds.set('LSTM_country_EPOCH', 50)
rds.set('LSTM_country_BATCH', 40)
rds.set('LSTM_country_LR', 0.001)
rds.set('LSTM_EPOCH', 25)
rds.set('LSTM_BATCH', 50)
rds.set('LSTM_LR', 0.001)
