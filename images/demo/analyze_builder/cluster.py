# -*- coding: utf-8 -*-
"""
Created on Tue Mar 27 18:00:56 2018

@author: jimmybow
"""
from mydf import *
from pymongo import MongoClient
import pytz
from datetime import datetime, timedelta
from sklearn import cluster, metrics
import sys
from usecase_incl import incl
import pickle
import redis
from pyclustering.cluster.cure import cure
from waveCluster import waveCluster
rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)

GMT = pytz.timezone('GMT')
print(datetime.now(GMT), 'cluster 開始 !', file = open('log.txt', 'a'))
init_time = datetime(2018,3,27,8,0,0, tzinfo = GMT)
now = int((datetime.now(GMT)-init_time).total_seconds()/60)

client = MongoClient(incl.mongo_connector)

db = client.demo
coll_visit = db.activities
coll_action = db.records

data_range = int(sys.argv[1])
time_range = [init_time + timedelta(minutes = now-6 - data_range + 1),
              init_time + timedelta(minutes = now-6)  ]
query1 = coll_visit.find({'minute': {'$gte': now - 6 - data_range + 1,
                                     '$lte': now - 6  }})
query2 = coll_action.find({'minute': {'$gte': now - 6 - data_range + 1,
                                      '$lte': now - 6  }})

df1 = pd.DataFrame([i for i in query1])
df1 >>= drop('_id', 'timestamp', 'minute')
df2 = pd.DataFrame([i for i in query2]) 
df2 >>= drop('_id', 'timestamp', 'minute')
df1['id'] = df1.country + '_' + df1.site + ' 的 ' + df1['product']
df2['id'] = df2.country + '_' + df2.site + ' 的 ' + df2['product']
df1 >>= drop('country', 'product', 'site')
df2 >>= drop('country', 'product', 'site')
df1 = pd.crosstab(df1.id, df1.visit)
df1.columns = df1.columns.name + '=' + df1.columns
df2 = pd.crosstab(df2.id, df2.action)
df2.columns = df2.columns.name + '=' + df2.columns

df = df1 >> bind_cols(df2) >> r(X.dropna(axis = 0))
rds.set('df_cluster', pickle.dumps(df))

###################################################################################
#############################       k-mean       ##################################
###################################################################################
# 找 k
silhouette_avgs = []
ks = range(5, 51)
for k in ks:
    print(k)
    km = cluster.KMeans(n_clusters = k, random_state = 42).fit(df)
    tags = km.labels_
    silhouette_avgs.append( metrics.silhouette_score(df, tags)  )

silhouette_avgs = np.array(silhouette_avgs)
ww = silhouette_avgs.argmax()
k = ks[ww]

km = cluster.KMeans(n_clusters = k, random_state = 42).fit(df)
tags = km.labels_
rds.set('tags_k-mean', pickle.dumps(tags))
rds.set('score_k-mean', silhouette_avgs[ww])
###################################################################################
#############################      CURE          ##################################
###################################################################################
data = df.as_matrix()
silhouette_avg =[]
ks = range(5, 51)
for k in ks:
    print('k =', k)
    cure_instance = cure(data, k, number_represent_points = 5, compression = 0.5)
    cure_instance.process()
    tags_index = cure_instance.get_clusters()
    tags = np.arange(len(data))
    for i, index in enumerate(tags_index): tags[index] = i
    silhouette_avg.append(  metrics.silhouette_score(data, tags)  )

silhouette_avg = np.array(silhouette_avg)
ww = silhouette_avg.argmax()

k = ks[ww]
cure_instance = cure(data, k, number_represent_points = 5, compression = 0.5)
cure_instance.process()
tags_index = cure_instance.get_clusters()
tags = np.arange(len(data))
for i, index in enumerate(tags_index): tags[index] = i

rds.set('tags_CURE', pickle.dumps(tags))
rds.set('score_CURE', silhouette_avg[ww])
###################################################################################
#############################      DBSCAN          ##################################
#########d##########################################################################
dbscan = cluster.DBSCAN(eps=1000, min_samples=3).fit(data)
tags = dbscan.labels_
silhouette =  metrics.silhouette_score(data[tags!=-1], tags[tags!=-1])
rds.set('tags_DBSCAN', pickle.dumps(tags))
rds.set('score_DBSCAN', silhouette)
###################################################################################
#############################      wavecluster          ############################
#########d##########################################################################
tags = waveCluster(data, scale=128, threshold=-0.01)
tags = np.array(tags)
silhouette =  metrics.silhouette_score(data[tags!=0], tags[tags!=0])
rds.set('tags_WaveCluster', pickle.dumps(tags))
rds.set('score_WaveCluster', silhouette)


rds.set('cluster_time_range', 'data from [{}] to [{}]'.format(time_range[0], time_range[1]))
print(datetime.now(GMT), 'cluster 完成 !', file = open('log.txt', 'a'))

