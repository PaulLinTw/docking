source ./0_common_conf.sh

eval $(docker-machine env az-worker1)
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

eval $(docker-machine env az-worker2)
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

eval $(docker-machine env az-worker3)
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
zkver="3.4.12"
eval $(docker-machine env az-worker1)
echo "create zk1 container"
docker run -d --net=$overlay --name=zk1 --expose 2181 --expose 2888 --expose 3888 \
--restart=always \
-v zkdata1:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.1:/zookeeper/$zkver/conf/zookeeper.cfg.1 \
$registry/demo/zookeeper:latest \
bash -c "echo 1 > var/zookeeper/myid && $zkver/bin/zkServer.sh start-foreground $zkver/conf/zookeeper.cfg.1"

eval $(docker-machine env az-worker2)
echo "create zk2 container"
docker run -d --net=$overlay --name=zk2 --expose 2181 --expose 2888 --expose 3888 \
--restart=always \
-v zkdata2:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.2:/zookeeper/$zkver/conf/zookeeper.cfg.2 \
$registry/demo/zookeeper:latest \
bash -c "echo 2 > var/zookeeper/myid && $zkver/bin/zkServer.sh start-foreground $zkver/conf/zookeeper.cfg.2"

eval $(docker-machine env az-worker3)
echo "create zk3 container"
docker run -d --net=$overlay --name=zk3 --expose 2181 --expose 2888 --expose 3888 \
--restart=always \
-v zkdata3:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.3:/zookeeper/$zkver/conf/zookeeper.cfg.3 \
$registry/demo/zookeeper:latest \
bash -c "echo 3 > var/zookeeper/myid && $zkver/bin/zkServer.sh start-foreground $zkver/conf/zookeeper.cfg.3"

sleep 5

eval $(docker-machine env az-worker1)
echo "create kafka1 container"
docker run -d --net=$overlay --name=kafka1 --expose 9092 --expose 9041 --expose 7071 \
--restart=always \
-v kafkadata1:/data/kafka-logs \
-v /home/$user/confs/server.properties.1:/kafka/0.11.0.2/config/server.properties.1 \
$registry/demo/kafka:latest bash -c "sh restart_kafka.sh 1"

eval $(docker-machine env az-worker2)
echo "create kafka2 container"
docker run -d --net=$overlay --name=kafka2 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata2:/data/kafka-logs \
--restart=always \
-v /home/$user/confs/server.properties.2:/kafka/0.11.0.2/config/server.properties.2 \
$registry/demo/kafka:latest bash -c "sh restart_kafka.sh 2"

eval $(docker-machine env az-worker3)
echo "create kafka3 container"
docker run -d --net=$overlay --name=kafka3 --expose 9092 --expose 9041 --expose 7071 \
--restart=always \
-v kafkadata3:/data/kafka-logs \
-v /home/$user/confs/server.properties.3:/kafka/0.11.0.2/config/server.properties.3 \
$registry/demo/kafka:latest bash -c "sh restart_kafka.sh 3"

sleep 5
eval $(docker-machine env az-worker1)
echo "create redis1 container"
docker run -d --net=$overlay --name=redis1 --expose 6379 \
--restart=always \
-v /home/$user/confs/redis.master.conf:/redis.conf \
$registry/demo/redis:latest bash -c "redis-server redis.conf"

eval $(docker-machine env az-worker2)
echo "create redis2 container"
docker run -d --net=$overlay --name=redis2 --expose 6379 \
--restart=always \
-v /home/$user/confs/redis.slave.conf:/redis.conf \
$registry/demo/redis:latest bash -c "redis-server redis.conf"

eval $(docker-machine env az-worker3)
echo "create redis3 container"
docker run -d --net=$overlay --name=redis3 --expose 6379 \
--restart=always \
-v /home/$user/confs/redis.slave.conf:/redis.conf \
$registry/demo/redis:latest bash -c "redis-server redis.conf"

sleep 5

eval $(docker-machine env az-master)

echo "create km container"
docker run -d --net=$overlay --name=km -p 8080:8080 \
--restart=always \
-v /home/$user/confs/application.conf:/km/conf/application.conf \
$registry/demo/km:latest bash -c "sh restart_km.sh"

echo "create prometheus container"
docker run -d --net=$overlay --name=prometheus -p 9090:9090 \
--restart=always \
-v prometheusdata:/opt/prometheus/data \
-v /home/$user/confs/prometheus.yml:/opt/prometheus/prometheus.yml \
$registry/demo/prometheus:latest \
bash -c "./prometheus --config.file=prometheus.yml"

echo "create grafana container"
docker run -d --privileged=true --net=$overlay --name=grafana -p 3000:3000 \
--restart=always \
-v grafanadata:/var/lib/grafana \
$registry/demo/grafana:latest \

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

echo "all service containers were created"
