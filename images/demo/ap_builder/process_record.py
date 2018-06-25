from usecase_incl import incl
import json
import redis
import time

from kafka import KafkaConsumer

consumer = KafkaConsumer(	incl.records_topic,
								group_id = incl.records_groupid,
								bootstrap_servers = incl.broker_list)
rds = redis.Redis(	host=incl.redis_servers, 
						password=incl.redis_pass, 
						port=incl.redis_port)
i=0
j=0
then = time.time()

for msg in consumer:
	record = json.loads( msg.value.replace("'", "\""));
	# write: to redis
	pipe = rds.pipeline()
	pipe.hincrby('product:'+record["action"],record["product"],1)
	pipe.hincrby(record["product"]+':country:'+record["action"],record["country"],1)
	pipe.hincrby(record["product"]+':site:'+record["action"],record["site"],1)
	pipe.execute()
	i=i+1
	if ((i-j)>incl.batchtotal):
		now = time.time()
		diff = now - then
		j=i
		print str(j)+" records processed. "+str(int(incl.batchtotal/diff))+" per second."
		then = now
