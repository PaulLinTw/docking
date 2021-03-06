source ./0_common_conf.sh

eval $(docker-machine env --swarm $Master_Host)

docker start zk1
docker start zk2
docker start zk3

docker start kafka1
docker start kafka2
docker start kafka3

docker start $(docker ps -f name=redis -aq)

docker start $(docker ps -f name=mongo -aq)

if [ $with_elk ] ; then
	echo "Starting ELK services.."
	docker start $(docker ps -f name=elasticsearch -aq)
	docker start kibana
	docker start $(docker ps -f name=logstash -aq)
fi
docker start grafana
docker start prometheus
docker start km

docker start portal
#docker start $(docker ps -f name=act_proc -aq)
#docker start $(docker ps -f name=rec_proc -aq)

docker start $(docker ps -f name=act_store -aq)
docker start $(docker ps -f name=rec_store -aq)


docker start $(docker ps -f name=act_sim -aq)
docker start $(docker ps -f name=rec_sim -aq)

docker start $(docker ps -f name=cadvisor -aq)
docker start clustering
docker start $(docker ps -f name=model -aq)
docker start $(docker ps -f name=remove -aq)
docker start $(docker ps -f name=count -aq)
docker start $(docker ps -f name=exporter -aq)

