source ./0_common_conf.sh

eval $(docker-machine env --swarm $Master_Host)
docker rm -f $(docker ps -f name=act_sim -aq)
docker rm -f $(docker ps -f name=rec_sim -aq)
docker rm -f analyze
docker rm -f $(docker ps -f name=remove -aq)
docker rm -f $(docker ps -f name=count -aq)
docker rm -f reporter
docker rm -f $(docker ps -f name=act_proc -aq)
docker rm -f $(docker ps -f name=rec_proc -aq)

docker rm -f $(docker ps -f name=act_store -aq)
docker rm -f $(docker ps -f name=rec_store -aq)

docker rm -f $(docker ps -f name=logstash -aq)
docker rm -f kibana
docker rm -f $(docker ps -f name=elasticsearch -aq)

docker rm -f grafana
docker rm -f prometheus
docker rm -f km

docker rm -f $(docker ps -f name=mongo -aq)

docker rm -f $(docker ps -f name=redis -aq)

docker rm -f $(docker ps -f name=kafka -aq)

docker rm -f $(docker ps -f name=zk -aq)
