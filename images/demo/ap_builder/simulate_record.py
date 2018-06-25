from usecase_incl import incl
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json
import random
import datetime
import time
import sys

#cmdline = "USAGE: Python simulate_records.py Country_Name"
#if len(sys.argv)<2:
#	print cmdline
#	sys.exit()

#rec_country = str(sys.argv[1])

#if not any(rec_country in p for p in incl.countrylist):
#	print "Invalid Country Name "+str(sys.argv[1])
#	print cmdline
#	sys.exit()

#try:
#	rps = int(sys.argv[2])
#	rps = incl.activities_per_second
#except:
#	print "Invalid rec_per_sec "+str(sys.argv[2])
#	print cmdline
#	sys.exit()

ProductCount={}
for p in incl.productlist:
	ProductCount[str(p)] = 0

ActionCount={}
for v in incl.actionlist:
	ActionCount[str(v)] = 0

Product_Rate = {}
Rate_Prd = incl.product_rate
for p in range(len(incl.productlist)):
        Product_Rate[str(incl.productlist[p])] = float(Rate_Prd[p])
print Product_Rate

Action_Rate = {}
Rate_Act = incl.record_rate
for a in range(len(incl.actionlist)):
        Action_Rate[str(incl.actionlist[a])] = float(Rate_Act[a])
print Action_Rate

producer = KafkaProducer(	bootstrap_servers = incl.broker_list, linger_ms=0 )
prdcount = float(0)
actcount = float(0)
j=0
while True:
	then = time.time()
	i=0
	for _ in range(incl.rps):
		try:
			prd = str(incl.productlist[random.randint(0, len(incl.productlist)-1)])
			prd_rate = Product_Rate[prd]
			prd_limit = prdcount * prd_rate
			act = str(incl.actionlist[random.randint(0, len(incl.actionlist)-1)])
			act_rate = Action_Rate[act]
			act_limit = actcount * act_rate
			bool1 = (prd_rate==1) or (ProductCount[prd]<prd_limit)
			bool2 = (act_rate==1) or (ActionCount[act]<act_limit)
			if (bool1) and (bool2):
				record =	{	"action": act, 
								"product": prd, 
								"country": incl.country, 
								"site": str(incl.sitelist[incl.country][random.randint(0, len(incl.sitelist[incl.country])-1)]), 
								"timestamp": str(datetime.datetime.now())
							}
				producer.send(incl.records_topic, json.dumps(record))
				ProductCount[prd]=ProductCount[prd]+1
				ActionCount[act]=ActionCount[act]+1
				if prd_rate==1:
					prdcount=ProductCount[prd]
				if act_rate==1:
					actcount=ActionCount[act]
				i=i+1
				j=j+1
		except KafkaError:
			# process exception
			print "error"
			log.exception()
			pass
	#producer.flush()
	time.sleep(incl.interval)
	now = time.time()
	diff = now - then
	print str(j)+" records sent. "+str(int(i/diff))+" per second."
