source ./0_common_conf.sh

eval $(docker-machine env $Worker1_Host)
echo "create cadvisor1 container"
docker run --net=$overlay \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor1 \
  google/cadvisor:latest

eval $(docker-machine env $Worker2_Host)
echo "create cadvisor2 container"
docker run --net=$overlay \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor2 \
  google/cadvisor:latest

eval $(docker-machine env $Worker3_Host)
echo "create cadvisor3 container"
docker run --net=$overlay \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor3 \
  google/cadvisor:latest

sleep 5

eval $(docker-machine env $Worker1_Host)
echo "create zk1 container"
docker run -d --net=$overlay --name=zk1 --expose 2181 --expose 2888 --expose 3888 \
-v zkdata1:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.1:/zookeeper/3.4.12/conf/zookeeper.cfg.1 \
$registry/demo/zookeeper:latest \
bash -c "echo 1 > var/zookeeper/myid && 3.4.12/bin/zkServer.sh start-foreground 3.4.12/conf/zookeeper.cfg.1"

#bash -c "echo 1 > var/zookeeper/myid && 3.4.12/bin/zkServer.sh start-foreground 3.4.12/conf/zookeeper.cfg.1"

eval $(docker-machine env $Worker2_Host)
echo "create zk2 container"
docker run -d --net=$overlay --name=zk2 --expose 2181 --expose 2888 --expose 3888 \
-v zkdata2:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.2:/zookeeper/3.4.12/conf/zookeeper.cfg.2 \
$registry/demo/zookeeper:latest \
bash -c "echo 2 > var/zookeeper/myid && 3.4.12/bin/zkServer.sh start-foreground 3.4.12/conf/zookeeper.cfg.2"

eval $(docker-machine env $Worker3_Host)
echo "create zk3 container"
docker run -d --net=$overlay --name=zk3 --expose 2181 --expose 2888 --expose 3888 \
-v zkdata3:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.3:/zookeeper/3.4.12/conf/zookeeper.cfg.3 \
$registry/demo/zookeeper:latest \
bash -c "echo 3 > var/zookeeper/myid && 3.4.12/bin/zkServer.sh start-foreground 3.4.12/conf/zookeeper.cfg.3"

sleep 5

eval $(docker-machine env $Worker1_Host)
echo "create kafka1 container"
docker run -d --net=$overlay --name=kafka1 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata1:/data \
-v kafkalog1:/data/kafka-logs \
-v /home/$user/confs/server.properties$aamode.1:/kafka/0.11.0.2/config/server.properties$aamode.1 \
$registry/demo/kafka:latest bash -c "sh restart_kafka$aamode.sh 1"

eval $(docker-machine env $Worker2_Host)
echo "create kafka2 container"
docker run -d --net=$overlay --name=kafka2 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata2:/data \
-v kafkalog2:/data/kafka-logs \
-v /home/$user/confs/server.properties$aamode.2:/kafka/0.11.0.2/config/server.properties$aamode.2 \
$registry/demo/kafka:latest bash -c "sh restart_kafka$aamode.sh 2"

eval $(docker-machine env $Worker3_Host)
echo "create kafka3 container"
docker run -d --net=$overlay --name=kafka3 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata3:/data \
-v kafkalog3:/data/kafka-logs \
-v /home/$user/confs/server.properties$aamode.3:/kafka/0.11.0.2/config/server.properties$aamode.3 \
$registry/demo/kafka:latest bash -c "sh restart_kafka$aamode.sh 3"

sleep 5
eval $(docker-machine env $Worker1_Host)
echo "create redis1 container"
docker run -d --net=$overlay --name=redis1 -p 6379:6379 \
-v redisdata1:/data \
-v /home/$user/confs/redis.master.conf:/redis.conf \
$registry/demo/redis:latest bash -c "redis-server redis.conf"

eval $(docker-machine env $Worker2_Host)
echo "create redis2 container"
docker run -d --net=$overlay --name=redis2 --expose 6379 \
-v redisdata2:/data \
-v /home/$user/confs/redis.slave.conf:/redis.conf \
$registry/demo/redis:latest bash -c "redis-server redis.conf"

eval $(docker-machine env $Worker3_Host)
echo "create redis3 container"
docker run -d --net=$overlay --name=redis3 --expose 6379 \
-v redisdata3:/data \
-v /home/$user/confs/redis.slave.conf:/redis.conf \
$registry/demo/redis:latest bash -c "redis-server redis.conf"


sleep 5

echo "create redis exporter"
eval $(docker-machine env $Master_Host)
docker run -d --net=$overlay --name=redis_exporter --expose 9121 \
-e "REDIS_ADDR=redis1:6379,redis2:6379,redis3:6379" \
-e "REDIS_PASSWORD=btdsclab" \
oliver006/redis_exporter:latest

echo "create km container"
docker run -d --net=$overlay --name=km -p 8080:8080 \
-v /home/$user/confs/application.conf:/km/conf/application.conf \
$registry/demo/km:latest bash -c "sh restart_km.sh"

echo "create prometheus container"
docker run -d --net=$overlay --name=prometheus -p 9090:9090 \
-v prometheusdata:/opt/prometheus/data \
-v /home/$user/confs/prometheus.yml:/opt/prometheus/prometheus.yml \
$registry/demo/prometheus:latest \
bash -c "./prometheus --config.file=prometheus.yml"

echo "create grafana container"
docker run -d --net=$overlay --name=grafana -p 3000:3000 \
-v grafanadata:/var/lib/grafana \
$registry/demo/grafana:latest

sleep 5

echo "create portal container"
docker run -d --net=$overlay --name=portal -p 5050:5050 \
-v /home/$user/confs/ap.conf:/app/tester.conf \
-v /home/$user/confs/app/app.py:/app/app.py \
-v /home/$user/confs/app/base/models.py:/app/base/models.py \
-v /home/$user/confs/app/base/routes.py:/app/base/routes.py \
-v /home/$user/confs/app/base/templates/:/app/base/templates/ \
-v /home/$user/confs/app/extends/:/app/extends/ \
-v /home/$user/confs/app/dashboards/:/app/dashboards/ \
-v /home/$user/confs/app/countries/:/app/countries/ \
-v /home/$user/confs/app/products/:/app/products/ \
-v /home/$user/confs/app/actions/:/app/actions/ \
-v /home/$user/confs/app/visits/:/app/visits/ \
-v /home/$user/confs/app/abouts/:/app/abouts/ \
$registry/demo/portal:latest

echo "all service containers were created. please check clusters by portainer"
