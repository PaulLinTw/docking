from ConfigParser import SafeConfigParser
import sys

class incl:

	parser = SafeConfigParser()
	parser.read('tester.conf')

	countrylist = ['China', 'India', 'USA', 'Indonesia', 'Japan', 'UK', 'France', 'Germany', 'Russia', 'Mexico']
	if (sys.argv[0] in ['simulate_activity.py','simulate_record.py']):
		country = str(sys.argv[1])
		print country
		aps = int(parser.get('act_per_sec', country))
		rps = int(parser.get('rec_per_sec', country))
		product_rate = parser.get('products', country ).split(",")
		activity_rate = parser.get('activities', country ).split(",")
		record_rate = parser.get('records', country ).split(",")

	broker_list= parser.get('kafka', 'brokers')
	redis_servers= parser.get('redis', 'server')
	redis_port= parser.get('redis', 'port')
	redis_pass= parser.get('redis', 'pass')

	mongo_datebase= parser.get('mongodb', 'datebase')
	mongo_connector= parser.get('mongodb', 'connector')
	mongo_bulksize= parser.get('mongodb', 'bulksize')
	mongo_group= parser.get('mongodb', 'storegrp')

	activities_topic= parser.get('activities', 'topic')
	activities_groupid= parser.get('activities', 'groupid')

	records_topic= parser.get('records', 'topic')
	records_groupid= parser.get('records', 'groupid')

	productlist = ['a-pad', 'a-watch', 'a-phone', 'a-tv', 'a-bike', 'a-camera', 'a-bot']
	countrycode = {	'China':'cn',
						'India':'in',
						'USA': 'us',
						'Indonesia':'id',
						'Japan':'jp',
						'UK':'gb',
						'France':'fr',
						'Germany':'de',
						'Russia':'ru',
						'Mexico':'mx' }
	sitelist ={ 	'China': ['Shanghai', 'Beijing', 'Guangzhou', 'Shenzhen', 'Tianjin'],
					'India': ['Mumbai', 'Delhi', 'Kolkata'],
					'USA': ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Philadelphia'],
					'Indonesia': ['Jakarta', 'Bali', 'Semarang'],
					'Japan': ['Tokyo', 'Keihanshin', 'Nagoya', 'Fukuoka'],
					'UK': ['London', 'Birmingham', 'Liverpool', 'Bristol', 'Sheffield'],
					'France': ['Paris', 'Marseille', 'Lyon', 'Toulouse'],
					'Germany': ['Berlin', 'Munich', 'Frankfurt', 'Hamburg'],
					'Russia': ['Moscow', 'St Petersburg', 'Novosibirsk', 'Yekaterinburg'],
					'Mexico': ['Mexico City', 'Iztapalapa', 'Guadalajara', 'Tijuana']
				}
	actionlist = ['sell', 'complaint', 'return']
	visitlist = ['news', 'store', 'support', 'forum']

	batchtotal = int(parser.get('tester', 'batchtotal'))
	interval = int(parser.get('tester', 'interval'))

	chart_width = float(parser.get('chart', 'width'))
	chart_height = float(parser.get('chart', 'height'))

	charts_prediction = str(parser.get('analysis', 'prediction')).replace(" ", "").split(",")
	charts_cluster = str(parser.get('analysis', 'cluster')).replace(" ", "").split(",")
	charts_interval = int(parser.get('analysis', 'interval'))
	charts_datarange = str(parser.get('analysis', 'datarange'))


