from usecase_incl import incl
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json
import random
import datetime
import time

#products = incl.productlist
#countries = incl.countrylist
#sites = incl.sitelist
#visits = incl.visitlist

producer = KafkaProducer(	bootstrap_servers = incl.broker_list, linger_ms=0 )
j=0
while True:
	then = time.time()
	for _ in range(incl.batchtotal):
		try:
			act_country = str(incl.countrylist[random.randint(0, len(incl.countrylist)-1)])
			activity =	{	"visit": str(incl.visitlist[random.randint(0, len(incl.visitlist)-1)]), 
							"product": str(incl.productlist[random.randint(0, len(incl.productlist)-1)]), 
							"country": act_country, 
							"site": str(incl.sitelist[act_country][random.randint(0, len(incl.sitelist[act_country])-1)]), 
							"timestamp": str(datetime.datetime.now())
						}
			producer.send(incl.activities_topic, json.dumps(activity))
		except KafkaError:
			# process exception
			print "error"
			log.exception()
			pass		
		j=j+1
	#producer.flush()
	time.sleep(incl.interval)
	now = time.time()
	diff = now - then
	print str(j)+" activities sent. "+str(int(incl.batchtotal/diff))+" per second."
