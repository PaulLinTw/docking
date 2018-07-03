source ./0_common_conf.sh

eval $(docker-machine env --swarm $Master_Host)
docker stop $(docker ps -f name=model -aq)
docker stop $(docker ps -f name=remove -aq)
docker stop $(docker ps -f name=count -aq)
docker stop $(docker ps -f name=exporter -aq)
docker stop clustering

docker stop $(docker ps -f name=act_sim -aq)
docker stop $(docker ps -f name=rec_sim -aq)

docker stop reporter
docker stop $(docker ps -f name=act_proc -aq)
docker stop $(docker ps -f name=rec_proc -aq)

docker stop $(docker ps -f name=act_store -aq)
docker stop $(docker ps -f name=rec_store -aq)

docker rm -f $(docker ps -f name=cadvisor -aq)

if [ $with_elk ] ; then
	echo "Stopping ELK Services.."
	docker stop $(docker ps -f name=logstash -aq)
	docker stop kibana
	docker stop $(docker ps -f name=elasticsearch -aq)
fi

docker stop grafana
docker stop prometheus
docker stop km

docker stop $(docker ps -f name=mongo -aq)

docker stop $(docker ps -f name=redis -aq)

docker stop $(docker ps -f name=kafka -aq)

docker stop $(docker ps -f name=zk -aq)
