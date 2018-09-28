source ./0_common_conf.sh

eval $(docker-machine env $Master_Host)
docker pull $registry/xpack/kibana
docker pull $registry/demo/mongodb
docker pull $registry/demo/prometheus
docker pull $registry/demo/km
docker pull $registry/demo/portal
docker pull $registry/demo/grafana

eval $(docker-machine env $Worker1_Host)
docker pull $registry/demo/kafka
docker pull $registry/demo/mongoexporter
docker pull $registry/demo/zookeeper
docker pull $registry/demo/redis
docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/logstash
docker pull $registry/demo/mongodb
docker pull $registry/sasl/kafka
docker pull $registry/sasl/zookeeper

eval $(docker-machine env $Worker2_Host)
docker pull $registry/demo/kafka
docker pull $registry/demo/mongoexporter
docker pull $registry/demo/zookeeper
docker pull $registry/demo/redis
docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/logstash
docker pull $registry/demo/mongodb
docker pull $registry/sasl/kafka
docker pull $registry/sasl/zookeeper

eval $(docker-machine env $Worker3_Host)
docker pull $registry/demo/kafka
docker pull $registry/demo/mongoexporter
docker pull $registry/demo/zookeeper
docker pull $registry/demo/redis
docker pull $registry/xpack/elasticsearch
docker pull $registry/xpack/logstash
docker pull $registry/demo/mongodb
docker pull $registry/sasl/kafka
docker pull $registry/sasl/zookeeper

#eval $(docker-machine env $Worker4_Host)
#docker pull $registry/demo/analyze
#docker pull $registry/demo/ap

#eval $(docker-machine env $Worker5_Host)
#docker pull $registry/demo/analyze
#docker pull $registry/demo/ap


