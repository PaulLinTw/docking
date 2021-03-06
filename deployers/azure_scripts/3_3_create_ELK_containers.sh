source ./0_common_conf.sh

echo "create kibana container"
eval $(docker-machine env az-master)
docker run -d --net=$overlay --name=kibana -p 5601:5601 \
--restart=always \
-v /home/$user/confs/kibana.yml:/usr/share/kibana/config/kibana.yml \
$registry/xpack/kibana:latest

sleep 5

eval $(docker-machine env az-worker1)
echo "create elasticsearch1 container"
docker run -d --net=$overlay --name=elasticsearch1 -e ES_JAVA_OPTS="-Xmx256m -Xms256m" -e ELASTIC_PASSWORD=changeme \
-v esdata1:/usr/share/elasticsearch/data \
-v /home/$user/confs/elasticsearch_cluster.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-p 9200:9200 -p 9300:9300 $registry/xpack/elasticsearch:latest

eval $(docker-machine env az-worker2)
echo "create elasticsearch2 container"
docker run -d --net=$overlay --name=elasticsearch2 -e ES_JAVA_OPTS="-Xmx256m -Xms256m" -e ELASTIC_PASSWORD=changeme \
-e discovery.zen.ping.unicast.hosts="elasticsearch1" \
-v esdata2:/usr/share/elasticsearch/data \
-v /home/$user/confs/elasticsearch_cluster.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-p 9200:9200 -p 9300:9300 $registry/xpack/elasticsearch:latest

eval $(docker-machine env az-worker3)
echo "create elasticsearch3 container"
docker run -d --net=$overlay --name=elasticsearch3 -e ES_JAVA_OPTS="-Xmx256m -Xms256m" -e ELASTIC_PASSWORD=changeme \
-e discovery.zen.ping.unicast.hosts="elasticsearch1" \
-v esdata3:/usr/share/elasticsearch/data \
-v /home/$user/confs/elasticsearch_cluster.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-p 9200:9200 -p 9300:9300 $registry/xpack/elasticsearch:latest

sleep 5

echo "create logstash1 container"
eval $(docker-machine env az-worker1)
docker run -d --net=$overlay --name=logstash1 -e LS_JAVA_OPTS="-Xmx256m -Xms256m" \
--restart=always \
-v /home/$user/confs/logstash.yml:/usr/share/logstash/config/logstash.yml \
-v /home/$user/confs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
$registry/xpack/logstash:latest

echo "create logstash2 container"
eval $(docker-machine env az-worker2)
docker run -d --net=$overlay --name=logstash2 -e LS_JAVA_OPTS="-Xmx256m -Xms256m" \
--restart=always \
-v /home/$user/confs/logstash.yml:/usr/share/logstash/config/logstash.yml \
-v /home/$user/confs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
$registry/xpack/logstash:latest

echo "create logstash3 container"
eval $(docker-machine env az-worker3)
docker run -d --net=$overlay --name=logstash3 -e LS_JAVA_OPTS="-Xmx256m -Xms256m" \
--restart=always \
-v /home/$user/confs/logstash.yml:/usr/share/logstash/config/logstash.yml \
-v /home/$user/confs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
$registry/xpack/logstash:latest

echo "all ELK containers were created. please check clusters by portainer"
