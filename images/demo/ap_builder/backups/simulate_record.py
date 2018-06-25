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
#actions = incl.actionlist

producer = KafkaProducer(	bootstrap_servers = incl.broker_list, linger_ms=0 )
j=0
while True:
	then = time.time()
	for _ in range(incl.batchtotal):
		try:
			rec_country = str(incl.countrylist[random.randint(0, len(incl.countrylist)-1)])
			record =	{	"action": str(incl.actionlist[random.randint(0, len(incl.actionlist)-1)]), 
							"product": str(incl.productlist[random.randint(0, len(incl.productlist)-1)]), 
							"country": rec_country, 
							"site": str(incl.sitelist[rec_country][random.randint(0, len(incl.sitelist[rec_country])-1)]), 
							"timestamp": str(datetime.datetime.now())
						}
			producer.send(incl.records_topic, json.dumps(record))
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
	print str(j)+" records sent. "+str(int(incl.batchtotal/diff))+" per second."
