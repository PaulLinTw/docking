load('/confs/demo.js');
var minute_start= new Date(CONFIG.datebase)
var rawSize = CONFIG.rawSize
var counter = 0
var edge = 0
while (1)
{
	var m = parseInt((new Date() - minute_start ) / 60000)
	if (m>counter)
	{
		print("check minute "+counter+" on minutes");
		c=db.minutes.find({ minute: counter }).count()
		if (c==0)
		{
			c=db.activities.find({ minute: counter }).count()
			if (c>0)
			{
				print("counting minute "+counter+" on activities");
				db.activities.aggregate( 
					{ $match: { minute : counter } }, 
					{ $group: { _id: {country:"$country",site:"$site",product:"$product",action:"$visit"}, count: { $sum: 1 } } } 
				).forEach( function(x) {
					obj = JSON.parse(tojson(x));
					d = { "minute":counter, "country":obj._id.country, "site":obj._id.site, "product":obj._id.product, "action":obj._id.action, "count":obj.count}
					db.minutes.insert(d);
				} );
			}
		}
		print("minute "+counter+" counted.");
		counter++;
	}
	else
	{
		sleep(1000);
	}
}
