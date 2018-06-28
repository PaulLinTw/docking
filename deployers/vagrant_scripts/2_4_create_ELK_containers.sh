user="vagrant"

eval $(docker-machine env worker1)
echo "create elasticsearch1 container"
docker run -d --net=multi --name=elasticsearch1 -e ES_JAVA_OPTS="-Xmx256m -Xms256m" -e ELASTIC_PASSWORD=changeme \
--restart=always \
-v esdata1:/usr/share/elasticsearch/data \
-v /home/$user/confs/elasticsearch_cluster.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-p 9200:9200 -p 9300:9300 btgit.eastasia.cloudapp.azure.com:5000/xpack/elasticsearch:latest

eval $(docker-machine env worker2)
echo "create elasticsearch2 container"
docker run -d --net=multi --name=elasticsearch2 -e ES_JAVA_OPTS="-Xmx256m -Xms256m" -e ELASTIC_PASSWORD=changeme \
--restart=always \
-e discovery.zen.ping.unicast.hosts="elasticsearch1" \
-v esdata2:/usr/share/elasticsearch/data \
-v /home/$user/confs/elasticsearch_cluster.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-p 9200:9200 -p 9300:9300 btgit.eastasia.cloudapp.azure.com:5000/xpack/elasticsearch:latest

eval $(docker-machine env worker3)
echo "create elasticsearch3 container"
docker run -d --net=multi --name=elasticsearch3 -e ES_JAVA_OPTS="-Xmx256m -Xms256m" -e ELASTIC_PASSWORD=changeme \
--restart=always \
-e discovery.zen.ping.unicast.hosts="elasticsearch1" \
-v esdata3:/usr/share/elasticsearch/data \
-v /home/$user/confs/elasticsearch_cluster.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-p 9200:9200 -p 9300:9300 btgit.eastasia.cloudapp.azure.com:5000/xpack/elasticsearch:latest

sleep 5

echo "create kibana container"
eval $(docker-machine env master1)
docker run -d --net=multi --name=kibana -p 5601:5601 \
--restart=always \
-v /home/$user/confs/kibana.yml:/usr/share/kibana/config/kibana.yml \
btgit.eastasia.cloudapp.azure.com:5000/xpack/kibana:latest

sleep 5

echo "create logstash1 container"
eval $(docker-machine env worker1)
docker run -d --net=multi --name=logstash1 -e LS_JAVA_OPTS="-Xmx256m -Xms256m" \
--restart=always \
-v /home/$user/confs/logstash.yml:/usr/share/logstash/config/logstash.yml \
-v /home/$user/confs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
btgit.eastasia.cloudapp.azure.com:5000/xpack/logstash:latest

echo "create logstash2 container"
eval $(docker-machine env worker2)
docker run -d --net=multi --name=logstash2 -e LS_JAVA_OPTS="-Xmx256m -Xms256m" \
--restart=always \
-v /home/$user/confs/logstash.yml:/usr/share/logstash/config/logstash.yml \
-v /home/$user/confs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
btgit.eastasia.cloudapp.azure.com:5000/xpack/logstash:latest

echo "create logstash3 container"
eval $(docker-machine env worker3)
docker run -d --net=multi --name=logstash3 -e LS_JAVA_OPTS="-Xmx256m -Xms256m" \
--restart=always \
-v /home/$user/confs/logstash.yml:/usr/share/logstash/config/logstash.yml \
-v /home/$user/confs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
btgit.eastasia.cloudapp.azure.com:5000/xpack/logstash:latest

echo "all ELK containers were created. please check clusters by portainer"
