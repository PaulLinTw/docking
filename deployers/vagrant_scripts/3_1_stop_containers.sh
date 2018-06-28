eval $(docker-machine env --swarm master1)
docker stop $(docker ps -f name=act_sim -aq)
docker stop $(docker ps -f name=rec_sim -aq)

docker stop reporter
docker stop $(docker ps -f name=act_proc -aq)
docker stop $(docker ps -f name=rec_proc -aq)

docker stop $(docker ps -f name=act_store -aq)
docker stop $(docker ps -f name=rec_store -aq)

docker stop $(docker ps -f name=logstash -aq)
docker stop kibana
docker stop $(docker ps -f name=elasticsearch -aq)
	
docker stop grafana
docker stop prometheus
docker stop km

docker stop $(docker ps -f name=mongo -aq)

docker stop $(docker ps -f name=redis -aq)

docker stop $(docker ps -f name=kafka -aq)

docker stop $(docker ps -f name=zk -aq)
