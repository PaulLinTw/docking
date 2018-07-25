id="admin"
pass="admin"
serverip="172.17.24.217"
serverport="3000"
download_folder="~/downloads"
redis_uid="sCAAU3imz"
mongo_uid="sCAAU3imz"
docker_uid="sCAAU3imz"
kafka_uid="sCAAU3imz"

echo download redis dashboard
curl "http://$id:$pass@$serverip:$serverport/api/dashboards/uid/$redis_uid" |python -c "import sys, json; data=json.load(sys.stdin); data'dashboard'=None; print json.dumps(data);" | python -m json.tool > $download_folder/redis.json

echo download mongo dashboard
curl "http://$id:$pass@$serverip:$serverport/api/dashboards/uid/$mongo_uid" |python -c "import sys, json; data=json.load(sys.stdin); data'dashboard'=None; print json.dumps(data);" | python -m json.tool > $download_folder/mongo.json

echo download docker dashboard
curl "http://$id:$pass@$serverip:$serverport/api/dashboards/uid/$docker_uid" |python -c "import sys, json; data=json.load(sys.stdin); data'dashboard'=None; print json.dumps(data);" | python -m json.tool > $download_folder/docker.json

echo download kafka dashboard
curl "http://$id:$pass@$serverip:$serverport/api/dashboards/uid/$kafka_uid" |python -c "import sys, json; data=json.load(sys.stdin); data'dashboard'=None; print json.dumps(data);" | python -m json.tool > $download_folder/kafka.json
