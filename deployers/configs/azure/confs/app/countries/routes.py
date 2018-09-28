from flask import Blueprint, render_template, url_for, redirect
from flask_login import login_required
from flask import request
from extends.usecase_incl import incl

to_chinese = {'forum':'論壇拜訪量',
    'news': '新聞拜訪量',
    'store':'商店拜訪量',
    'support': '客服拜訪量',
    'complaint': '客訴量',
    'return':'退貨量',
    'sell':  '銷售量'}    

blueprint = Blueprint(
    'countries_blueprint',
    __name__,
    url_prefix='/countries',
    template_folder='templates',
    static_folder='static'
)

def getanalysis(key):
	import redis
	rds = redis.Redis(host=incl.redis_servers, password=incl.redis_pass, port=incl.redis_port)
	x=rds.get(key)
	return x.decode('utf-8')

@blueprint.route('/index', methods=['GET'])
@login_required
def index():
	country=request.args.get("country")
	hourrange=request.args.get("hourrange")
	algorithm=request.args.get("algorithm")
	product=request.args.get("product")
	action=request.args.get("action")
	if hourrange==None:
		hourrange="60"
	if country==None:
		country="China"
	if algorithm==None:
		algorithm="MLP"
	if product==None:
		product="a-tv"
	if action==None:
		action="sell"

	import extends.prediction_plot_LSTM_country as ppsc
	import extends.prediction_plot_LSTM_s1_country as ppsc_s1
	import extends.prediction_plot_MLP_country as ppmc
	import extends.prediction_plot_country as ppc

	title="對 "+country+" 的產品 "+product+" 之"+to_chinese[action]+'預測'
	if algorithm=="MLP":
		model=ppmc.load_model()
		timerange=getanalysis('prediction_mlp_range')
		predict_dict=ppmc.Forcast_and_Plot_Country(model=model, product=product, country=country, action=action)
	elif algorithm=="LSTM":
		model=ppsc.load_model()
		timerange=getanalysis('prediction_LSTM_range')
		predict_dict=ppsc.Forcast_and_Plot_Country(model=model, product=product, country=country, action=action)
	elif algorithm=="LSTM_Seq_To_One":
		model=ppsc_s1.load_model()
		timerange=getanalysis('prediction_LSTM_s1_range')
		predict_dict=ppsc_s1.Forcast_and_Plot_Country(model=model, product=product, country=country, action=action)
	else:
		model=ppc.load_model()
		timerange=getanalysis('prediction_tree_range')
		predict_dict=ppc.Forcast_and_Plot_Country(model=model, product=product, country=country, action=action)

	prediction={'title':title,'image':predict_dict["div"],'rmse15':'%.2f'%predict_dict["RMSE_15"], 'timerange':timerange, 'algorithm':algorithm}

	import extends.statistic_plot as sp
	ranking=sp.get_country_plotly(country=country, product=product, act=action, data_range=int(hourrange))

	import extends.relation_plot as rp
	relations=rp.get_country_relation(country=country, product=product)

	return render_template('index.html', algorithm=algorithm, prediction=prediction, ranking=ranking, relations=relations, product=product, country=country, action=action, refresher=60, hourrange=hourrange)

@blueprint.route('/<template>')
@login_required
def route_template(template):
    return render_template(template + '.html')
