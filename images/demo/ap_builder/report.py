#coding:utf-8
import web
import time
from usecase_incl import incl
import os
import pygal
import sys
import urllib2

reload(sys)  
sys.setdefaultencoding('utf8')

urls = (
    '/', 'index',
    '/map', 'map',
    '/cluster', 'cluster',
    '/prediction', 'prediction',
    '/relation', 'relation',
    '/favicon.ico', 'icon'
)

def getstatus(key,catagory):
	import redis
	import operator
	rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
	x=rds.hgetall('product:'+key)
	sorted_x = sorted(x.items(), key=operator.itemgetter(1))
	product=sorted_x[0][0]
	stat="<h3>全球「"+catagory+"」最高商品︰"+product+'('+str(sorted_x[0][1])+')</h3>前 3 高國家︰'
	x=rds.hgetall(product+':country:'+key)
	sorted_x = sorted(x.items(), key=operator.itemgetter(1))
	sorted_x.reverse()
	i=0
	for item in sorted_x:
		stat = stat +item[0]+'('+str(item[1])+'). '
		i=i+1
		if i>2:
			break

	bar_chart = pygal.Bar() 
	for item in sorted_x:
		bar_chart.add(item[0], [int(item[1])])
	#bar_chart.render_to_file("static/product_country_"+key+".svg")
	bar_chart.disable_xml_declaration=True
	svg1=bar_chart.render(width=incl.chart_width, height=incl.chart_height, explicit_size=True, is_unicode=True)
	stat = stat + '<br>前 3 高銷售據點（城市）︰'
	x=rds.hgetall(product+':site:'+key)
	sorted_x = sorted(x.items(), key=operator.itemgetter(1))
	sorted_x.reverse()
	i=0
	for item in sorted_x:
		stat = stat +item[0]+'('+str(item[1])+'). '
		i=i+1
		if i>2:
			break

	Pie_chart = pygal.Pie() 
	i=0
	for item in sorted_x:
		Pie_chart.add(item[0], [int(item[1])])
		i=i+1
		if i>9:
			break
	#Pie_chart.render_to_file("static/product_site_"+key+".svg")
	Pie_chart.disable_xml_declaration=True
	svg2=Pie_chart.render(width=incl.chart_width, height=incl.chart_height, explicit_size=True, is_unicode=True)

	return '<div><h4>'+stat+'<BR>'+svg1+svg2+'</h4></div>'

def getlist(product,data):
	import redis
	import operator
	rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
	x=rds.hgetall(product+':country:'+data)
	sorted_x = sorted(x.items(), key=operator.itemgetter(1))
	sorted_x.reverse()
	return sorted_x

def getanalysis(key):
	import redis
	rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
	x=rds.get(key)
	return str(x)

# Process favicon.ico requests
class icon:
	def GET(self): raise web.seeother("/static/favicon.ico")

class index:
	def GET(self):
		# get data from redis
		status=getstatus('news','新聞網頁訪問')+getstatus('store','商店網頁訪問')+getstatus('support','客服網頁訪問')+getstatus('forum','論壇網頁訪問')+getstatus('sell','銷售記錄')+getstatus('complaint','客訴記錄')+getstatus('return','退貨記錄')
		rtn='<html>\n	<head>\n		<title>網站活動與交易即時狀態</title>\n		<meta http-equiv="content-type" content="text/html;charset=utf-8"><meta http-equiv="refresh" content="10" />\n	</head>\n	<body>'+status+'</body>\n</html>'
		return rtn

class map:
	def GET(self):
		user_data = web.input()
		prd=user_data.product
		pg=user_data.data
		from pygal.maps.world import World
		wm = World(height=400)
		wm.force_uri_protocol = 'http'
		wm.title="產品 "+prd+" 的 "+pg+" 在全球即時分佈的狀態"
		d=getlist(prd,pg)
		i=0
		for item in d:
			x={}
			x[incl.countrycode[item[0]]]=item[1]
			wm.add(str(i+1)+". "+item[0], x)
			i=i+1
		#wm.render_to_file("static/map.svg")
		wm.disable_xml_declaration=True
		return '<html>\n        <head>\n                <title>全球即時分佈圖</title>\n<meta http-equiv="content-type" content="text/html;charset=utf-8"><meta http-equiv="refresh" content="30" />\n<script type="text/javascript" src="http://kozea.github.com/pygal.js/latest/pygal-tooltips.min.js"></script>\n</head>\n<body>\n'+wm.render(is_unicode=True)+'\n </body>\n</html>'

class cluster:
	def GET(self):
		user_data = web.input()
		key1=user_data.key1
		key2=user_data.key2
		if (key1==key2):
			return "請使用兩個不同的關鍵字"
		# get data from redis
		status=getanalysis('cluster_time_range')+'<br>';
		for key in incl.charts_cluster:
			if (str(key).find(key1)>0) and ((str(key).find(key2)>0)):
				chart=getanalysis(str(key))
				if chart<>None:
					status=status+chart
		rtn='<html>\n	<head>\n<title>網站活動與交易關聯探索</title>\n<meta http-equiv="content-type" content="text/html;charset=utf-8">\n<script src="https://cdn.plot.ly/plotly-latest.min.js"></script></head>\n<body>'+status+'</body>\n</html>'
		return rtn

class prediction:
	def GET(self):
		user_data = web.input(country="",site="",product="")
		country=user_data.country
		site=user_data.site
		product=user_data.product
		if ((country=="") and (site=="")) or (product==""):
			return "請使用 country(或 site) 以及 product 兩個參數"
		# get data from redis
		if country!="":
			contents = urllib2.urlopen("http://api:19090/prediction?country="+country+"&&product="+product).read()
		else:
			contents = urllib2.urlopen("http://api:19090/prediction?site="+site+"&&product="+product).read()
		
		rtn='<html>\n	<head>\n<title>網站活動與交易預測</title>\n<meta http-equiv="content-type" content="text/html;charset=utf-8">\n<meta http-equiv="refresh" content="60" />\n<script src="https://cdn.plot.ly/plotly-latest.min.js"></script></head>\n<body>'+getanalysis('prediction_tree_range')+'<br>'+'<div style="height:300px">'+contents+'</div>'+'</body>\n</html>'
		return rtn

class relation:
	def GET(self):
		user_data = web.input()
		key1=user_data.key1
		key2=user_data.key2
		if (key1==key2):
			return "請使用兩個不同的關鍵字"
		# get data from redis
		rules=str(getanalysis("rules")).split(',')
		status=getanalysis('rules_time_range')+'<br>'
		for rule in rules:
			if (str(rule).find(key1)>=0) and ((str(rule).find(key2)>=0)):
				status=status+rule+'<br>'
		rtn='<html>\n	<head>\n<title>網站活動與交易關聯分析</title>\n<meta http-equiv="content-type" content="text/html;charset=utf-8"></head>\n<body><h4>'+status+'</h4></body>\n</html>'
		return rtn

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
