eval $(docker-machine env --swarm master1)

docker start zk1
docker start zk2
docker start zk3

docker start kafka1
docker start kafka2
docker start kafka3

docker start $(docker ps -f name=redis -aq)

docker start $(docker ps -f name=mongo -aq)

docker start $(docker ps -f name=elasticsearch -aq)

docker start grafana
docker start prometheus
docker start km

docker start reporter
docker start $(docker ps -f name=act_proc -aq)
docker start $(docker ps -f name=rec_proc -aq)

docker start $(docker ps -f name=act_store -aq)
docker start $(docker ps -f name=rec_store -aq)

docker start kibana
docker start $(docker ps -f name=logstash -aq)

docker start $(docker ps -f name=act_sim -aq)
docker start $(docker ps -f name=rec_sim -aq)


