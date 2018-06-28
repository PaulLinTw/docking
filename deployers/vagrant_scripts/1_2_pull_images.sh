#/bin/bash!
registry="btgit.eastasia.cloudapp.azure.com:5000"
eval $(docker-machine env --swarm master1)

docker pull $registry/demo/base
docker pull $registry/demo/java8
docker pull $registry/demo/zookeeper
docker pull $registry/demo/redis
docker pull $registry/demo/prometheus
docker pull $registry/demo/km
docker pull $registry/demo/ap
docker pull $registry/demo/kafka
docker pull $registry/demo/mongodb

docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/kibana
docker pull $registry/xpack/logstash

docker pull $registry/demo/analyze
docker pull $registry/demo/mongoexporter
docker pull $registry/demo/portal
