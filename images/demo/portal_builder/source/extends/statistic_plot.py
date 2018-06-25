# -*- coding: utf-8 -*-
"""
Created on Tue Apr 17 16:29:36 2018

@author: jimmybow
"""

from mydf import *
import redis
from usecase_incl import incl
import sys
from plotly.offline import plot
import plotly.graph_objs as go
#sys.exit()

action = {'news':'新聞網頁訪問',
          'store':'商店網頁訪問',
          'support':'客服網頁訪問',
          'forum':'論壇網頁訪問',
          'sell':'銷售記錄',
          'complaint':'客訴記錄',
          'return':'退貨記錄'}

def get_plotly(key, output_type = 'div'):
    rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
    x = pd.DataFrame([rds.hgetall('product:'+ key)])
    x.columns = x.columns.astype(str)
    x.iloc[0] = x.iloc[0].astype(int)
    highest_product = x.iloc[0].argmax()
    title_1 = "全球「" + action[key] + "」最高商品︰" + highest_product + '(' + str(x[highest_product].iloc[0])+')'
    
    df_c = pd.DataFrame([rds.hgetall(highest_product+':country:'+key)])
    df_c.columns = df_c.columns.astype(str)
    df_c.iloc[0] = df_c.iloc[0].astype(int)
    highest_country = df_c.iloc[0].sort_values(ascending = False).iloc[:3]
    ss = highest_country.index + '(' + highest_country.astype(str) + ').'
    title_2 = "前 3 高國家︰" + ' '.join(ss)
    
    df_s = pd.DataFrame([rds.hgetall(highest_product+':site:'+key)])
    df_s.columns = df_s.columns.astype(str)
    df_s.iloc[0] = df_s.iloc[0].astype(int)
    highest_site = df_s.iloc[0].sort_values(ascending = False).iloc[:3]
    ss = highest_site.index + '(' + highest_country.astype(str) + ').'
    title_3 = "前 3 高銷售據點（城市）︰" + ' '.join(ss)
    
    ### plotly 畫圖 ###
    conf = dict(scrollZoom = True,
                displaylogo= False,
                showLink = False,
                displayModeBar = False,
                modeBarButtonsToRemove = [
                'sendDataToCloud',
                'zoomIn2d',
                'zoomOut2d',
                'hoverClosestCartesian',
                'hoverCompareCartesian',
                'hoverClosest3d',
                'hoverClosestGeo',
                'resetScale2d'])
    
    data = []
    for i in df_c.iloc[0].sort_values(ascending = False).index:
        trace = go.Bar(
            name = i,    
            x = [i],
            y = list(df_c[i]),
            hoverinfo = 'text',
            text = i + '；' + str(df_c[i].iloc[0])
        )
        data.append(trace)
        
    layout= go.Layout(
        showlegend=False,    
        dragmode = 'pan',
        hovermode= 'closest',
        xaxis= dict(
            title= '國家',
            titlefont=dict(
                size=18
            )
        ),
        yaxis=dict(
            title= action[key]+'次數',
            titlefont=dict(
                size=18
            )
        ),
        margin=dict(l=60,r=30,t=30,b=60)
    )
    
    fig= {'data':data,'layout':layout}
    country_div = plot(fig, output_type = output_type, config=conf)
    
    trace = go.Pie( 
        labels = list(df_s.columns),
        values = list(df_s.iloc[0]),
        hole = .4
    )
    
    layout= go.Layout(
        showlegend=False,
        margin=dict(l=0,r=0),
        annotations=[{
                "font": {
                    "size": 20
                },
                "showarrow": False,
                "text": "地區",
                "x": 0.5,
                "y": 0.5
            }]
    )
    
    fig= {'data':[trace], 'layout': layout}
    site_div = plot(fig, output_type = output_type, config=conf)
    return({'title_1':title_1,
            'title_2':title_2,
            'title_3':title_3,
            'bar':country_div,
            'pie':site_div})

# get_plotly('sell')
# get_plotly('sell', 'file')

