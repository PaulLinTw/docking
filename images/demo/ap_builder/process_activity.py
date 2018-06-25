from usecase_incl import incl
import json
import redis
import time

from kafka import KafkaConsumer

consumer = KafkaConsumer(	incl.activities_topic,
								group_id = incl.activities_groupid,
								bootstrap_servers = incl.broker_list)
rds = redis.Redis(	host=incl.redis_servers, 
						password=incl.redis_pass,
						port=incl.redis_port)
i=0
j=0
then = time.time()

for msg in consumer:
	activity = json.loads( msg.value.replace("'", "\""));
	# write: to redis
	pipe = rds.pipeline()
	pipe.hincrby('product:'+activity["visit"],activity["product"],1)
	pipe.hincrby(activity["product"]+':country:'+activity["visit"],activity["country"],1)
	pipe.hincrby(activity["product"]+':site:'+activity["visit"],activity["site"],1)
	pipe.execute()
	i=i+1
	if ((i-j)>incl.batchtotal):
		now = time.time()
		diff = now - then
		j=i
		print str(j)+" activities processed. "+str(int(incl.batchtotal/diff))+" per second."
		then = now
