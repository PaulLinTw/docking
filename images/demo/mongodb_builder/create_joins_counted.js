if (mnt==null){
	print('Please call this js in shell: mongo demo --port 40000 --eval "var mnt=19511" create_.js');
	quit()
}

load('/confs/demo.js');

db.joins_counted.remove({});

for(var nation in sites){
	var cities = sites[nation];
	for(var city in cities){
		for(var prd in products){
			for(var act in actions){
				m = db.minutes.find({ minute:mnt, country:nation, site:cities[city], product: products[prd], action:actions[act] })
				cnt=0;
				m.forEach(function(x){
					obj=JSON.parse(JSON.stringify(x));
					cnt=obj.count;
				});
				d = {"country":nation, "site":cities[city], "product": products[prd], "action":actions[act], "count":cnt }
				db.joins_counted.insert(d);
			}
			for(var vis in visits){
				m = db.minutes.find({ minute:mnt, country:nation, site:cities[city], product: products[prd], action:actions[act] })
				cnt=0;
				m.forEach(function(x){
					obj=JSON.parse(JSON.stringify(x));
					cnt=obj.count;
				});
				d = { "country":nation, "site":cities[city], "product": products[prd], "action":visits[vis], "count":cnt }
				db.joins_counted.insert(d);
			}
		}
	}
}
