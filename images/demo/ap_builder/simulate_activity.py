from usecase_incl import incl
from kafka import KafkaProducer
from kafka.errors import KafkaError
import json
import random
import datetime
import time
import sys

#cmdline = "USAGE: Python simulate_activity.py Country_Name"
#if len(sys.argv)<2:
#	print cmdline
#	sys.exit()

#act_country = str(sys.argv[1])

#if not any(act_country in p for p in incl.countrylist):
#	print "Invalid Country Name "+str(sys.argv[1])
#	print cmdline
#	sys.exit()

#try:
#	aps = int(sys.argv[2])
#	aps = incl.records_per_second
#except:
#	print "Invalid act_per_sec "+str(sys.argv[2])
#	print cmdline
#	sys.exit()

ProductCount={}
for p in incl.productlist:
	ProductCount[str(p)] = 0

PageCount={}
for v in incl.visitlist:
	PageCount[str(v)] = 0

Product_Rate = {}
Rate_Prd = incl.product_rate
for p in range(len(incl.productlist)):
        Product_Rate[str(incl.productlist[p])] = float(Rate_Prd[p])
print Product_Rate

Activity_Rate = {}
Rate_Act = incl.activity_rate
for a in range(len(incl.visitlist)):
        Activity_Rate[str(incl.visitlist[a])] = float(Rate_Act[a])
print Activity_Rate

producer = KafkaProducer(	bootstrap_servers = incl.broker_list, linger_ms=0 )
prdcount = float(0)
pagcount = float(0)
j=0
while True:
	then = time.time()
	i=0
	for _ in range(incl.aps):
		try:
			prd = str(incl.productlist[random.randint(0, len(incl.productlist)-1)])
			prd_rate = Product_Rate[prd]
			prd_limit = prdcount * prd_rate
			pag = str(incl.visitlist[random.randint(0, len(incl.visitlist)-1)])
			pag_rate = Activity_Rate[pag]
			pag_limit = pagcount * pag_rate
			bool1 = (prd_rate==1) or (ProductCount[prd]<prd_limit)
			bool2 = (pag_rate==1) or (PageCount[pag]<pag_limit)
			if (bool1) and (bool2):
				activity =	{	"visit": pag, 
								"product": prd, 
								"country": incl.country, 
								"site": str(incl.sitelist[incl.country][random.randint(0, len(incl.sitelist[incl.country])-1)]), 
								"timestamp": str(datetime.datetime.now())
							}
				producer.send(incl.activities_topic, json.dumps(activity))
				ProductCount[prd]=ProductCount[prd]+1
				PageCount[pag]=PageCount[pag]+1
				if prd_rate==1:
					prdcount=ProductCount[prd]
				if pag_rate==1:
					pagcount=PageCount[pag]
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
	print str(j)+" activities sent. "+str(int(i/diff))+" per second."
