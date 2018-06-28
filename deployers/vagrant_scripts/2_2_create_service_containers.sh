user="vagrant"

eval $(docker-machine env worker1)
echo "create zk1 container"
docker run -d --net=multi --name=zk1 --expose 2181 --expose 2888 --expose 3888 \
--restart=always \
-v zkdata1:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.1:/zookeeper/3.4.11/conf/zookeeper.cfg.1 \
btgit.eastasia.cloudapp.azure.com:5000/demo/zookeeper:latest \
bash -c "echo 1 > var/zookeeper/myid && 3.4.11/bin/zkServer.sh start-foreground 3.4.11/conf/zookeeper.cfg.1"

eval $(docker-machine env worker2)
echo "create zk2 container"
docker run -d --net=multi --name=zk2 --expose 2181 --expose 2888 --expose 3888 \
--restart=always \
-v zkdata2:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.2:/zookeeper/3.4.11/conf/zookeeper.cfg.2 \
btgit.eastasia.cloudapp.azure.com:5000/demo/zookeeper:latest \
bash -c "echo 2 > var/zookeeper/myid && 3.4.11/bin/zkServer.sh start-foreground 3.4.11/conf/zookeeper.cfg.2"

eval $(docker-machine env worker3)
echo "create zk3 container"
docker run -d --net=multi --name=zk3 --expose 2181 --expose 2888 --expose 3888 \
--restart=always \
-v zkdata3:/zookeeper/var/zookeeper \
-v /home/$user/confs/zookeeper.cfg.3:/zookeeper/3.4.11/conf/zookeeper.cfg.3 \
btgit.eastasia.cloudapp.azure.com:5000/demo/zookeeper:latest \
bash -c "echo 3 > var/zookeeper/myid && 3.4.11/bin/zkServer.sh start-foreground 3.4.11/conf/zookeeper.cfg.3"

sleep 5

eval $(docker-machine env worker1)
echo "create kafka1 container"
docker run -d --net=multi --name=kafka1 --expose 9092 --expose 9041 --expose 7071 \
--restart=always \
-v kafkadata1:/data/kafka-logs \
-v /home/$user/confs/server.properties.1:/kafka/0.11.0.2/config/server.properties.1 \
btgit.eastasia.cloudapp.azure.com:5000/demo/kafka:latest bash -c "sh restart_kafka.sh 1"

eval $(docker-machine env worker2)
echo "create kafka2 container"
docker run -d --net=multi --name=kafka2 --expose 9092 --expose 9041 --expose 7071 \
--restart=always \
-v kafkadata2:/data/kafka-logs \
-v /home/$user/confs/server.properties.2:/kafka/0.11.0.2/config/server.properties.2 \
btgit.eastasia.cloudapp.azure.com:5000/demo/kafka:latest bash -c "sh restart_kafka.sh 2"

eval $(docker-machine env worker3)
echo "create kafka3 container"
docker run -d --net=multi --name=kafka3 --expose 9092 --expose 9041 --expose 7071 \
--restart=always \
-v kafkadata3:/data/kafka-logs \
-v /home/$user/confs/server.properties.3:/kafka/0.11.0.2/config/server.properties.3 \
btgit.eastasia.cloudapp.azure.com:5000/demo/kafka:latest bash -c "sh restart_kafka.sh 3"

sleep 5
eval $(docker-machine env worker1)
echo "create redis1 container"
docker run -d --net=multi --name=redis1 -p 6379:6379 \
--restart=always \
-v /home/$user/confs/redis.master.conf:/redis.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/redis:latest bash -c "redis-server redis.conf"

eval $(docker-machine env worker2)
echo "create redis2 container"
docker run -d --net=multi --name=redis2 --expose 6379 \
--restart=always \
-v /home/$user/confs/redis.slave.conf:/redis.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/redis:latest bash -c "redis-server redis.conf"

eval $(docker-machine env worker3)
echo "create redis3 container"
docker run -d --net=multi --name=redis3 --expose 6379 \
--restart=always \
-v /home/$user/confs/redis.slave.conf:/redis.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/redis:latest bash -c "redis-server redis.conf"


sleep 5

eval $(docker-machine env master1)

echo "create km container"
docker run -d --net=multi --name=km -p 8080:8080 \
--restart=always \
-v /home/$user/confs/application.conf:/km/conf/application.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/km:latest bash -c "sh restart_km.sh"

echo "create prometheus container"
docker run -d --net=multi --name=prometheus --expose 9090 \
--restart=always \
-v prometheusdata:/opt/prometheus/data \
-v /home/$user/confs/prometheus.yml:/opt/prometheus/prometheus.yml \
btgit.eastasia.cloudapp.azure.com:5000/demo/prometheus:latest \
bash -c "./prometheus --config.file=prometheus.yml"

echo "create grafana container"
docker run -d --net=multi --name=grafana -p 3000:3000 \
--restart=always \
-v grafanadata:/var/lib/grafana \
grafana/grafana:latest

echo "all service containers were created. please check clusters by portainer"
