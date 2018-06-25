# -*- coding: utf-8 -*-
"""
Created on Tue Mar 13 10:23:04 2018

@author: jimmybow
"""

from mydf import *
import myapriori
from pymongo import MongoClient
import pytz
from datetime import datetime, timedelta
import sys
from usecase_incl import incl

GMT = pytz.timezone('GMT')
print(datetime.now(GMT), 'apriori 開始 !', file = open('log.txt', 'a'))
init_time = datetime(2018,3,27,8,0,0, tzinfo = GMT)
now = int((datetime.now(GMT)-init_time).total_seconds()/60)

client = MongoClient(incl.mongo_connector)

db = client.demo
coll_visit = db.activities
coll_action = db.records
print('connection db ok !', file = open('log.txt', 'a'))
data_range = int(sys.argv[1])
time_range = [init_time + timedelta(minutes = now-6 - data_range + 1),
              init_time + timedelta(minutes = now-6)  ]
query1 = coll_visit.find({'minute': {'$gte': now - 6 - data_range + 1,
                                     '$lte': now - 6  }})
query2 = coll_action.find({'minute': {'$gte': now - 6 - data_range + 1,
                                      '$lte': now - 6  }})
df1 = pd.DataFrame([i for i in query1]) 
df1 >>= drop('_id', 'timestamp', 'minute')
print('loding df1 ok !', file = open('log.txt', 'a'))
df1.site = df1.country + '_' + df1.site
df1 >>= drop('country')
visit_rules = myapriori.run(data = df1, supp = 0.0001, conf = 0.3,  lift = 1.2, maxlen = 10) >> arrange('lift', ascending = False) 
del(df1)
print('df1 ok !', file = open('log.txt', 'a'))
df2 = pd.DataFrame([i for i in query2]) 
df2 >>= drop('_id', 'timestamp', 'minute')
print('loding df2 ok !', file = open('log.txt', 'a'))
df2.site = df2.country + '_' + df2.site
df2 >>= drop('country')
action_rules = myapriori.run(data = df2, supp = 0.0001, conf = 0.3,  lift = 1.2, maxlen = 10) >> arrange('lift', ascending = False) 
del(df2)
print('df2 ok !', file = open('log.txt', 'a'))
client.close()
#visit_trans = myapriori.df_to_trans(df1)
#action_trans = myapriori.df_to_trans(df2)
#visit_rules
#action_rules

# action_rules.to_dict('record')

to_chinese = {
    'visit=forum':'論壇拜訪',
    'visit=news': '新聞拜訪',
    'visit=store':'商店拜訪',
    'visit=support': '客服拜訪',
    'action=complaint': '被客訴',
    'action=return':'被退貨',
    'action=sell':  '被銷售'}    
visit_rules >>= mutate(str_lift = case_when([X.lift>1.5, '非常高的'],
                                            [X.lift>1.3, '高的'],
                                            [X.lift>=1.1, '一定的']))
action_rules >>= mutate(str_lift = case_when([X.lift>1.5, '非常高的'],
                                             [X.lift>1.3, '高的'],
                                             [X.lift>=1.1, '一定的']))

string = []
for i in visit_rules.to_dict('record'):
    g = pd.Series(i['lhs']).str.split('=')
    g = pd.Series(list(g.str.get(1)), index = g.str.get(0))
    g = g.loc[['site', 'product', 'visit']]
    if pd.notnull(g.loc['visit']):
        g.loc['visit'] = (g.loc['visit']
        .replace('forum','論壇拜訪')
        .replace('news','新聞拜訪')
        .replace('store','商店拜訪')
        .replace('support','客服拜訪')
        .replace('complaint','被客訴')
        .replace('return','被退貨')
        .replace('sell','被銷售')
        )
    g = g.reset_index(drop = True) + pd.Series([' 地區', ' 產品', ''])
    g = '的 '.join(g.dropna())
    if 'visit=' in i['rhs']:      str_rhs = to_chinese[i['rhs']]
    elif 'product=' in i['rhs'] :  str_rhs = i['rhs'].split('=').pop()  + ' 產品'
    elif 'site=' in i['rhs'] :     str_rhs = i['rhs'].split('=').pop() + ' 地區'
    g = ' 與 '.join([g, str_rhs])
    g = g + ' 有' + i['str_lift'] + '相關性'   
    g = g.replace('Mexico_\tMexico City', 'Mexico_Mexico City')
    string.append(g)

for i in action_rules.to_dict('record'):
    g = pd.Series(i['lhs']).str.split('=')
    g = pd.Series(list(g.str.get(1)), index = g.str.get(0))
    g = g.loc[['site', 'product', 'action']]
    if pd.notnull(g.loc['action']):
        g.loc['action'] = (g.loc['action']
        .replace('forum','論壇拜訪')
        .replace('news','新聞拜訪')
        .replace('store','商店拜訪')
        .replace('support','客服拜訪')
        .replace('complaint','被客訴')
        .replace('return','被退貨')
        .replace('sell','被銷售')
        )
    g = g.reset_index(drop = True) + pd.Series([' 地區', ' 產品', ''])
    g = '的 '.join(g.dropna())
    if 'action=' in i['rhs']:      str_rhs = to_chinese[i['rhs']]
    elif 'product=' in i['rhs'] :  str_rhs = i['rhs'].split('=').pop()  + ' 產品'
    elif 'site=' in i['rhs'] :     str_rhs = i['rhs'].split('=').pop() + ' 地區'
    g = ' 與 '.join([g, str_rhs])
    g = g + ' 有' + i['str_lift'] + '相關性'  
    g = g.replace('Mexico_\tMexico City', 'Mexico_Mexico City')
    string.append(g)


string = pd.Series(string).str.replace('_', ' 的 ')
import redis
rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
rds.set('rules', ','.join(string))
rds.set('rules_time_range', 'data from [{}] to [{}]'.format(time_range[0], time_range[1]))

if 'rules' not in db.collection_names(): db.create_collection('rules')
rules = db.rules
rules.remove()
rules.insert(visit_rules.to_dict('record'))
rules.insert(action_rules.to_dict('record'))

print(datetime.now(GMT), 'apriori 完成 !', file = open('log.txt', 'a'))
