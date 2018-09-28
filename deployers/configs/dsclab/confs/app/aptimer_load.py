# -*- coding: utf-8 -*-
"""
Created on Sat Mar 31 13:51:10 2018

@author: jimmybow
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Mar 21 13:32:12 2018

@author: jimmybow
"""

from apscheduler.schedulers.blocking import BlockingScheduler 
from datetime import datetime
import subprocess
import os
import sys
from extends.usecase_incl import incl
from bson.objectid import ObjectId
import pickle
import redis
import gridfs
from sklearn.externals import joblib
from pymongo import MongoClient

root = os.path.abspath(os.path.dirname(__file__))
sched = BlockingScheduler() 
rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
client = MongoClient(incl.mongo_connector)
db  = client['model']
fs = gridfs.GridFS(db)
def load_model_tree(): 
    get_key = rds.get('prediction_key').decode()
    get_key_last = rds.get('prediction_key_last')
    if get_key_last is None : get_key_last = ''
    else : get_key_last = get_key_last.decode()
    rds.set('prediction_key_last', get_key)
    if get_key != get_key_last:
        model = pickle.loads(fs.get(ObjectId(get_key)).read())
        joblib.dump(model, '/models/Tree')
    
def load_model_tree_country(): 
    get_key = rds.get('prediction_key_country').decode()
    get_key_last = rds.get('prediction_key_last_country')
    if get_key_last is None : get_key_last = ''
    else : get_key_last = get_key_last.decode()
    rds.set('prediction_key_last_country', get_key)
    if get_key != get_key_last:
        model = pickle.loads(fs.get(ObjectId(get_key)).read())
        joblib.dump(model, '/models/Tree_country')
        
sched.add_job(load_model_tree        , 'interval', seconds = 30, next_run_time = datetime(2018,3,21,0,5))
sched.add_job(load_model_tree_country, 'interval', seconds = 30, next_run_time = datetime(2018,3,21,0,10))
sched.start()
