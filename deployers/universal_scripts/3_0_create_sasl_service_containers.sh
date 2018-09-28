source ./0_common_conf.sh

eval $(docker-machine env $Worker1_Host)
echo "create zk1 container"
docker run -d --net=$overlay --name=zk1 --expose 2181 --expose 2888 --expose 3888 \
-v zkdata1:/zookeeper/var/zookeeper \
-v /home/$user/confs/zk/zk1$aamode.jaas:/jaas/zookeeper.jaas \
-v /home/$user/confs/kerberos/krb5.conf:/etc/krb5.conf \
-v /home/$user/confs/keytabs/zk_zk1.kt:/keytabs/zk_zk1.kt \
-v /home/$user/confs/zk/zookeeper.cfg$aamode.1:/zookeeper/3.4.12/conf/zookeeper.cfg.1 \
$registry/sasl/zookeeper:latest \
bash -c "echo 1 > var/zookeeper/myid && sh /zookeeper/restart_zk$aamode.sh 1"

eval $(docker-machine env $Worker2_Host)
echo "create zk2 container"
docker run -d --net=$overlay --name=zk2 --expose 2181 --expose 2888 --expose 3888 \
-v zkdata2:/zookeeper/var/zookeeper \
-v /home/$user/confs/zk/zk2$aamode.jaas:/jaas/zookeeper.jaas \
-v /home/$user/confs/kerberos/krb5.conf:/etc/krb5.conf \
-v /home/$user/confs/keytabs/zk_zk2.kt:/keytabs/zk_zk2.kt \
-v /home/$user/confs/zk/zookeeper.cfg$aamode.2:/zookeeper/3.4.12/conf/zookeeper.cfg.2 \
$registry/sasl/zookeeper:latest \
bash -c "echo 2 > var/zookeeper/myid && sh /zookeeper/restart_zk$aamode.sh 2 "

eval $(docker-machine env $Worker3_Host)
echo "create zk3 container"
docker run -d --net=$overlay --name=zk3 --expose 2181 --expose 2888 --expose 3888 \
-v zkdata3:/zookeeper/var/zookeeper \
-v /home/$user/confs/zk/zk3$aamode.jaas:/jaas/zookeeper.jaas \
-v /home/$user/confs/kerberos/krb5.conf:/etc/krb5.conf \
-v /home/$user/confs/keytabs/zk_zk3.kt:/keytabs/zk_zk3.kt \
-v /home/$user/confs/zk/zookeeper.cfg$aamode.3:/zookeeper/3.4.12/conf/zookeeper.cfg.3 \
$registry/sasl/zookeeper:latest \
bash -c "echo 3 > var/zookeeper/myid && sh /zookeeper/restart_zk$aamode.sh 3"

sleep 5

eval $(docker-machine env $Worker1_Host)
echo "create kafka1 container"
docker run -d --net=$overlay --name=kafka1 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata1:/data \
-v /home/$user/confs/kafka/kafka1$aamode.jaas:/jaas/broker.jaas \
-v /home/$user/confs/kerberos/krb5.conf:/etc/krb5.conf \
-v /home/$user/confs/keytabs/kafka_kafka1.kt:/keytabs/kafka_kafka1.kt \
-v kafkalog1:/data/kafka-logs \
-v /home/$user/confs/kafka/server.properties$aamode.1:/kafka/0.11.0.2/config/server.properties.1 \
$registry/sasl/kafka:latest bash -c "sh restart_kafka$aamode.sh 1"

eval $(docker-machine env $Worker2_Host)
echo "create kafka2 container"
docker run -d --net=$overlay --name=kafka2 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata2:/data \
-v /home/$user/confs/kafka/kafka2$aamode.jaas:/jaas/broker.jaas \
-v /home/$user/confs/kerberos/krb5.conf:/etc/krb5.conf \
-v /home/$user/confs/keytabs/kafka_kafka2.kt:/keytabs/kafka_kafka2.kt \
-v kafkalog2:/data/kafka-logs \
-v /home/$user/confs/kafka/server.properties$aamode.2:/kafka/0.11.0.2/config/server.properties.2 \
$registry/sasl/kafka:latest bash -c "sh restart_kafka$aamode.sh 2"

eval $(docker-machine env $Worker3_Host)
echo "create kafka3 container"
docker run -d --net=$overlay --name=kafka3 --expose 9092 --expose 9041 --expose 7071 \
-v kafkadata3:/data \
-v /home/$user/confs/kafka/kafka3$aamode.jaas:/jaas/broker.jaas \
-v /home/$user/confs/kerberos/krb5.conf:/etc/krb5.conf \
-v /home/$user/confs/keytabs/kafka_kafka3.kt:/keytabs/kafka_kafka3.kt \
-v kafkalog3:/data/kafka-logs \
-v /home/$user/confs/kafka/server.properties$aamode.3:/kafka/0.11.0.2/config/server.properties.3 \
$registry/sasl/kafka:latest bash -c "sh restart_kafka$aamode.sh 3"

echo "all service containers were created. please check clusters by portainer"
