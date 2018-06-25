load('/confs/demo.js');
var minute_start= new Date(CONFIG.datebase)
var rawSize = CONFIG.rawSize
var minuteSize = CONFIG.minuteSize
var edge = 0
while (1)
{
	var m = parseInt((new Date() - minute_start ) / 60000)
	if (m>edge)
	{
		edge = m ;
		print("clear minutes older then "+ (edge - minuteSize) );
		db.minutes.remove({ minute: {$lt: (edge - minuteSize) }});
	}
	sleep(1000);
}
