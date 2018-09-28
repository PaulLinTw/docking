from flask import Blueprint, render_template
from flask_login import login_required
from flask import request
from extends.usecase_incl import incl
import extends.cluster_plot as clusterplot
blueprint = Blueprint(
    'dashboards_blueprint',
    __name__,
    url_prefix='/dashboards',
    template_folder='templates',
    static_folder='static'
)
to_chinese = {'forum':'論壇拜訪量',
    'news': '新聞拜訪量',
    'store':'商店拜訪量',
    'support': '客服拜訪量',
    'complaint': '客訴量',
    'return':'退貨量',
    'sell':  '銷售量'}    

def getanalysis(key):
	import redis
	rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
	x=rds.get(key)
	return x.decode("utf-8")

def getlist(product,data):
	import redis
	rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
	return rds.hgetall(product+':country:'+data)

@blueprint.route('/ranking')
@login_required
def ranking():
	axis_outer=request.args.get("axis_outer")
	axis_inner=request.args.get("axis_inner")
	hourrange=request.args.get("hourrange")
	if hourrange==None:
		hourrange="60"
	if axis_outer==None:
		axis_outer="country"
	if axis_inner==None:
		axis_inner="product"
	import extends.statistic_plot as sp
	ranking=sp.cross_plotly(cross_A=axis_outer, cross_B=axis_inner, data_range=int(hourrange))
	return render_template('ranking.html', ranking=ranking, axis_outer=axis_outer, axis_inner=axis_inner, hourrange=hourrange, refresher=60)

@blueprint.route('/predicting')
@login_required
def predicting():
	algorithm=request.args.get("algorithm")
	country=request.args.get("country")
	product=request.args.get("product")
	action=request.args.get("action")
	if algorithm==None:
		algorithm="MLP"
	if country==None:
		country="China"
	if action==None:
		action="sell"
	if product==None:
		product="a-tv"
	import extends.prediction_plot_MLP_each as ppme
	import extends.prediction_plot_LSTM_each as pple
	import extends.prediction_plot_LSTM_s1_each as pple_s1
	import extends.prediction_plot_each as ppe

	if algorithm=="MLP":
		model_each=ppme.load_model()
		timerange=getanalysis('prediction_mlp_range')
	elif algorithm=="LSTM":
		model_each=pple.load_model()
		timerange=getanalysis('prediction_LSTM_range')
	elif algorithm=="LSTM_Seq_To_One":
		model_each=pple_s1.load_model()
		timerange=getanalysis('prediction_LSTM_s1_range')
	else:
		model_each=ppe.load_model()
		timerange=getanalysis('prediction_tree_range')

	sites=incl.sitelist[country]
	predictions=[]
	for site in sites:
		title="對 "+country+" 的城市 "+site+" 產品 "+product+" 之"+to_chinese[action]+'預測'
		print(title)
		if algorithm=="MLP":
			predict_dict=ppme.Forcast_and_Plot(model=model_each, product=product, country=country, site=site, action=action)
		elif algorithm=="LSTM":
			predict_dict=pple.Forcast_and_Plot(model=model_each, product=product, country=country, site=site, action=action)
		elif algorithm=="LSTM_Seq_To_One":
			predict_dict=pple_s1.Forcast_and_Plot(model=model_each, product=product, country=country, site=site, action=action)
		else:
			predict_dict=ppe.Forcast_and_Plot(model=model_each, product=product, country=country, site=site, action=action)
		#print(image)
		predictions.append({'title':title,'image':predict_dict["div"],'rmse15':'%.2f'%predict_dict["RMSE_15"]})

	return render_template('predicting.html', predictions=predictions, product=product, country=country, site=site, action=action, algorithm=algorithm, timerange=timerange, refresher=60)

@blueprint.route('/clustering_2D')
@login_required
def clustering_2D():
	algorithm=request.args.get("algorithm")
	key1=request.args.get("key1")
	key2=request.args.get("key2")
	if algorithm==None:
		algorithm="k-mean"
	if key1==None:
		key1="news"
	if key2==None:
		key2="sell"
	timerange=getanalysis('cluster_time_range')
	cluster_score=getanalysis('score_'+algorithm)
	if key1 in ['news','store','forum','support'] : x_name = 'visit='+key1
	else : x_name = 'action='+key1
	if key2 in ['news','store','forum','support'] : y_name = 'visit='+key2
	else : y_name = 'action='+key2
	chart=clusterplot.draw2Dplotly(x_name=x_name, y_name=y_name, algorithm=algorithm)
	title=to_chinese[key1]+"、"+to_chinese[key2]+' 之間的分佈參照'
	print(title)
	Cluster2D={'title':title,'image':chart}
	return render_template('clustering_2D.html', algorithm=algorithm, Cluster2D=Cluster2D, timerange=timerange, option1=key1, option2=key2, Score=cluster_score)

@blueprint.route('/clustering_3D')
@login_required
def clustering_3D():
	algorithm=request.args.get("algorithm")
	key1=request.args.get("key1")
	key2=request.args.get("key2")
	key3=request.args.get("key3")
	if algorithm==None:
		algorithm="k-mean"
	if key1==None:
		key1="news"
	if key2==None:
		key2="sell"
	if key3==None:
		key3="support"
	timerange=getanalysis('cluster_time_range')
	cluster_score=getanalysis('score_'+algorithm)
	if key1 in ['news','store','forum','support'] : x_name = 'visit='+key1
	else : x_name = 'action='+key1
	if key2 in ['news','store','forum','support'] : y_name = 'visit='+key2
	else : y_name = 'action='+key2
	if key3 in ['news','store','forum','support'] : z_name = 'visit='+key3
	else : z_name = 'action='+key3
	chart=clusterplot.draw3Dplotly(x_name=x_name, y_name=y_name, z_name=z_name, algorithm=algorithm)
	title=to_chinese[key1]+"、"+to_chinese[key2]+"、"+to_chinese[key3]+' 之間的分佈參照'
	print(title)
	Cluster3D={'title':title,'image':chart}
	return render_template('clustering_3D.html', algorithm=algorithm, Cluster3D=Cluster3D, timerange=timerange, option1=key1, option2=key2, option3=key3, Score=cluster_score)

@blueprint.route('/worldmap', methods=['GET'])
@login_required
def wordmap():
	product=request.args.get("product")
	action=request.args.get("action")
	hourrange=request.args.get("hourrange")
	if hourrange==None:
		hourrange="60"
	if product==None:
		product="a-tv"
	if action==None:
		action="sell"

	import extends.statistic_plot as sp
	worldmap=sp.world_map_plot(product=product, action=action, data_range=int(hourrange))
	return render_template('worldmap.html', worldmap=worldmap, product=product, action=action, hourrange=hourrange, refresher=30)

@blueprint.route('/<template>')
@login_required
def route_template(template):
    return render_template(template + '.html')
