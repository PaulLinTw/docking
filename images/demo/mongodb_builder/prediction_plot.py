# -*- coding: utf-8 -*-
"""
Created on Tue Apr  3 11:05:12 2018

@author: jimmybow
"""

from mydf import *
from sklearn import datasets, metrics
from sklearn.feature_extraction import DictVectorizer
from pymongo import MongoClient
from datetime import datetime, timedelta
import pytz
import sys
from usecase_incl import incl
import pickle
import redis

def time_to_str(t): 
    s = datetime.strftime(init_time + timedelta(minutes = t), '%Y-%m-%d day %H hour %M minute')
    return(s.replace('day', '日').replace('hour', '點').replace('minute', '分'))
    
def read_data(product='a-tv', country='China'):
    GMT = pytz.timezone('GMT')
    init_time = datetime(2018,3,27,8,0,0, tzinfo = GMT)
    now = int((datetime.now(GMT)-init_time).total_seconds()/60)
    
    client = MongoClient(incl.mongo_connector)
    db = client.demo
    coll = db.minutes
    
    data_range = 20
    time_range = [init_time + timedelta(minutes = now-1 - data_range + 1),
                  init_time + timedelta(minutes = now-1 )  ]
    
    query = coll.find({'minute': {'$gte': now - 1  - data_range + 1,
                                  '$lte': now - 1   },
                       'product':product,
                       'country':country})
    
    df = pd.DataFrame([i for i in query])
    
    df >>= ( drop('_id')
     >> rename(action_type = 'action', counts = 'count')
     >> select('minute', 'action_type', 'country', 'product', 'site', 'counts')
     >> arrange('minute') >> mutate(
            **{'counts_t-1': X.counts.shift(1),
               'counts_t-2': X.counts.shift(2),
               'counts_t-3': X.counts.shift(3),
               'counts_t-4': X.counts.shift(4),
               'counts_t-5': X.counts.shift(5)} )
     >> r(X.dropna())
    )
    return df

def Forcast(df, k=10):
    rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
    Tree = pickle.loads(rds.get('prediction_tree'))
    vec = pickle.loads(rds.get('prediction_vec'))
    t_name = 'minute'
    
    ddf = df >> arrange(t_name)
    pre_value = []
    t_value = []
    current_feature = ddf >> tail(1) >> r(X.iloc[0,5:])
    for i in range(k):
        current_feature = current_feature.shift(1)
        data = current_feature.iloc[1:].to_dict()
        data.update(df >> tail(1) >> select('action_type', 'country', 'product', 'site') >> r(X.iloc[0].to_dict()))
        p = Tree.predict(vec.transform(data))[0]
        pre_value.append(p)
        t_value.append(df >> tail(1) >> r(X[t_name].astype(int).iloc[0] + i+1 ))
        current_feature.iloc[0] = p
    df_true = ddf.iloc[:,:6]    
    df_true['pre_value'] = False    
    df_pre = pd.DataFrame({t_name:t_value,
                         'action_type': ddf.action_type.iloc[0],
                         'site' : ddf.site.iloc[0],
                         'product' : ddf['product'].iloc[0],
                         'country' : ddf.country.iloc[0],
                         'counts' : pre_value,
                         'pre_value' : True})
    return df_true >> bind_rows(df_pre)

### plotly 畫圖 ###
from plotly.offline import plot
import plotly.graph_objs as go

to_chinese = {
    'forum':'論壇拜訪量',
    'news': '新聞拜訪量',
    'store':'商店拜訪量',
    'support': '客服拜訪量',
    'complaint': '客訴量',
    'return':'退貨量',
    'sell':  '銷售量'}    

def draw2Dplotly(df_pre, output_type = 'file'):
    t_name = 'minute'
    conf = dict(scrollZoom = True,
                displaylogo= False,
                showLink = False,
                modeBarButtonsToRemove = [
                'sendDataToCloud',
                'zoomIn2d',
                'zoomOut2d',
                'hoverClosestCartesian',
                'hoverCompareCartesian',
                'hoverClosest3d',
                'hoverClosestGeo',
                'resetScale2d'])
    
    current_t = df_pre[~df_pre.pre_value][t_name].max()
    ww = where(df_pre[t_name]==current_t)[0]
       
    trace = go.Scatter(
        name = '實際值',    
        x = df_pre[~df_pre.pre_value][t_name],
        y = df_pre[~df_pre.pre_value].counts,
        mode = 'lines+markers',
        hoverinfo = 'text',
        text = df_pre[~df_pre.pre_value][t_name].apply(time_to_str) + '<br>實際值: ' + df_pre[~df_pre.pre_value].counts.astype(int).astype(str),
        line = dict(color = 'rgb(0, 0, 255)')
    )
    
    trace_pre = go.Scatter(
        name = '預測值',    
        x = df_pre[df_pre.pre_value][t_name],
        y = df_pre[df_pre.pre_value].counts,
        mode = 'lines+markers',
        hoverinfo = 'text',
        text = df_pre[df_pre.pre_value][t_name].apply(time_to_str) + '<br>預測值: ' + df_pre[df_pre.pre_value].counts.astype(str),
        line = dict(color = 'rgb(255, 0, 0)',
                    dash = 'dot')
    )
        
    trace_con = go.Scatter(   
        x = df_pre[t_name].iloc[ww:ww+2],
        y = df_pre.counts.iloc[ww:ww+2],
        mode = 'lines',
        line = dict(color = 'rgb(255, 0, 0)',
                    dash = 'dot')
    )     
    
    layout= go.Layout(
        title= '{}-{} 的 {} 之{}預測'.format(df_pre.country.iloc[0],
                                                        df_pre.site.iloc[0],
                                                        df_pre['product'].iloc[0],
                                                        to_chinese[df_pre.action_type.iloc[0]]),
        titlefont=dict(
            size=30
        ),
        dragmode = 'pan',
        hovermode= 'closest',
        showlegend=False,
        xaxis= dict(
            title= '時間 ({})'.format(t_name),
            titlefont=dict(
                size=18
            ),
            tickvals = df_pre[t_name],
            ticktext = df_pre[t_name].apply(lambda t: datetime.strftime(init_time + timedelta(minutes = t), '%H:%M'))
            
        ),
        yaxis=dict(
            title= to_chinese[df_pre.action_type.iloc[0]],
            titlefont=dict(
                size=18
            )
        )
    )
    
    fig= {'data':[trace_con, trace_pre, trace], 'layout':layout}
    div = plot(fig, output_type = output_type, config=conf)
    return(div)

def Forcast_and_Plot(country='China', product='a-tv'):
    df = read_data(country=country,  product= product)
    div = []
    for site in df.site.unique():
        for action_type in df.action_type.unique():
            df_pre = Forcast(df >> mask(X.site == site, X.action_type==action_type))
            div.append(draw2Dplotly(df_pre, output_type = 'div'))
    return '<br>'.join(div)

# df = read_data(product='a-tv', country='China')
# df_pre = Forcast(df >> mask(X.site == 'Beijing', X.action_type=='sell'))

# df_pre
# div = draw2Dplotly(df_pre)
# g=Forcast_and_Plot()
# print(g, file = open('abc.txt', 'w'))

