#coding=utf-8
from usecase_incl import incl
import json
import time
import datetime
import pymongo
from pymongo import MongoClient
from pymongo.errors import BulkWriteError
from kafka import KafkaConsumer
import pandas

consumer = KafkaConsumer(	incl.activities_topic,
								group_id = incl.mongo_group,
								bootstrap_servers = incl.broker_list)

client = MongoClient(incl.mongo_connector)
db = client.demo
collection=db.activities

i=0
j=0
then = time.time()
minute_start = pandas.to_datetime(incl.mongo_datebase)
print "minute count started from "+minute_start.isoformat()
bulklen = 0
# reset array 清空陣列
bulkdoc = []
for msg in consumer:
	activity = json.loads( msg.value.replace("'", "\""))
	ts = pandas.to_datetime(activity['timestamp'])
	activity['timestamp'] = ts.isoformat()
	activity['minute'] = ((ts-minute_start).days*86400 + (ts-minute_start).seconds ) / 60
	bulklen = bulklen + len(activity)
	bulkdoc.append( activity.copy() )
	if (bulklen > int(incl.mongo_bulksize) ):
		bulklen = 0
		try:
			inserted = collection.insert_many( bulkdoc )
		except BulkWriteError as bwe:
			print bwe.details	
			pass	
		bulkdoc = []
	i=i+1
	if ((i-j)>incl.batchtotal):
		now = time.time()
		diff = now - then
		j=i
		print str(j)+" activities stored. "+str(int(incl.batchtotal/diff))+" per second. "+str(activity['minute'])
		then = now

