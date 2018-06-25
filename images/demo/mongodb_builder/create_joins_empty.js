load('/confs/demo.js');

db.joins.remove({});

for(var country in sites){
	print("country:"+country);
	var cities = sites[country];
	for(var city in cities){
		print("  city:"+cities[city]);
		for(var prd in products){
			print("    product:"+products[prd]);
			for(var act in actions){
				print("      action:"+actions[act]);
				d = { "country":country, "site":cities[city], "product": products[prd], "action":actions[act] }
				db.joins.insert(d);
			}
			for(var vis in visits){
				print("      visit:"+visits[vis]);
				d = { "country":country, "site":cities[city], "product": products[prd], "action":visits[vis] }
				db.joins.insert(d);
			}
		}
	}
}
