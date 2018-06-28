source ./0_common_conf.sh

eval $(docker-machine env --swarm az-master)
docker pull $registry/demo/mongodb

eval $(docker-machine env az-worker1)
docker pull $registry/demo/zookeeper
docker pull $registry/demo/kafka
docker pull $registry/demo/redis
docker pull $registry/demo/ap
docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/logstash
docker pull $registry/demo/mongodb

eval $(docker-machine env az-worker2)
docker pull $registry/demo/zookeeper
docker pull $registry/demo/kafka
docker pull $registry/demo/redis
docker pull $registry/demo/ap
docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/logstash
docker pull $registry/demo/mongodb

eval $(docker-machine env az-worker3)
docker pull $registry/demo/zookeeper
docker pull $registry/demo/kafka
docker pull $registry/demo/redis
docker pull $registry/demo/ap
docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/logstash
docker pull $registry/demo/mongodb

eval $(docker-machine env az-master)
docker pull $registry/demo/prometheus
docker pull $registry/demo/mongoexporter
docker pull $registry/demo/km
docker pull $registry/demo/portal
docker pull $registry/xpack/kibana
docker pull $registry/demo/grafana
docker pull $registry/demo/mongodb

eval $(docker-machine env az-analyze1)
docker pull $registry/demo/analyze
