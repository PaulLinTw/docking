from ConfigParser import SafeConfigParser

class incl:
	parser = SafeConfigParser()
	parser.read('tester.conf')

	broker_list= parser.get('kafka', 'brokers')
	redis_servers= parser.get('redis', 'server')
	redis_port= parser.get('redis', 'port')
	redis_pass= parser.get('redis', 'pass')

	activities_topic= parser.get('activities', 'topic')
	activities_groupid= parser.get('activities', 'groupid')

	records_topic= parser.get('records', 'topic')
	records_groupid= parser.get('records', 'groupid')
	
	product_country_list = { 'China': parser.get('products', 'China'),
								 'India': parser.get('products', 'India'),
								 'USA': parser.get('products', 'USA'),
								 'Indonesia': parser.get('products', 'Indonesia'),
								 'Japan': parser.get('products', 'Japan'),
								 'UK': parser.get('products', 'UK'),
								 'France': parser.get('products', 'France'),
								 'Germany': parser.get('products', 'Germany'),
								 'Russia': parser.get('products', 'Russia'),
								 'Mexico': parser.get('products', 'Mexico')							 
								}

	activity_country_list = { 'China': parser.get('activities', 'China'),
								 'India': parser.get('activities', 'India'),
								 'USA': parser.get('activities', 'USA'),
								 'Indonesia': parser.get('activities', 'Indonesia'),
								 'Japan': parser.get('activities', 'Japan'),
								 'UK': parser.get('activities', 'UK'),
								 'France': parser.get('activities', 'France'),
								 'Germany': parser.get('activities', 'Germany'),
								 'Russia': parser.get('activities', 'Russia'),
								 'Mexico': parser.get('activities', 'Mexico')							 
								}

	record_country_list =  { 'China': parser.get('records', 'China'),
								 'India': parser.get('records', 'India'),
								 'USA': parser.get('records', 'USA'),
								 'Indonesia': parser.get('records', 'Indonesia'),
								 'Japan': parser.get('records', 'Japan'),
								 'UK': parser.get('records', 'UK'),
								 'France': parser.get('records', 'France'),
								 'Germany': parser.get('records', 'Germany'),
								 'Russia': parser.get('records', 'Russia'),
								 'Mexico': parser.get('records', 'Mexico')							 
								}

	productlist = ['a-pad', 'a-watch', 'a-phone', 'a-tv', 'a-bike', 'a-camera', 'a-bot']
	countrylist = ['China', 'India', 'USA', 'Indonesia', 'Japan', 'UK', 'France', 'Germany', 'Russia', 'Mexico']
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
					'Mexico': ['	Mexico City', 'Iztapalapa', 'Guadalajara', 'Tijuana']
				}
	actionlist = ['sell', 'complaint', 'return']
	visitlist = ['news', 'store', 'support', 'forum']

	batchtotal = int(parser.get('tester', 'batchtotal'))
	interval = int(parser.get('tester', 'interval'))
