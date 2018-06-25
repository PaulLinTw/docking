load('/confs/demo.js');
var minute_start= new Date(CONFIG.datebase)
var rawSize = CONFIG.rawSize
var edge = 0
while (1)
{
	var m = parseInt((new Date() - minute_start ) / 60000)
	if (m>edge)
	{
		edge = m ;
		print("clear activities older then "+ (edge - rawSize) );
		db.activities.remove({ minute: {$lt: (edge - rawSize) }});
	}
	sleep(1000);
}
