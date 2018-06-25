#/bin/bash!
ZK_HOSTS="zk1:2181,zk2:2181,zk3:2181"
cd /kafka/0.11.0.2/
bin/kafka-topics.sh --create --zookeeper $ZK_HOSTS --replication-factor 3 --partitions 3 --topic activities --config retention.ms=21600000 --config retention.bytes=6318000000 --config segment.ms=3600000 --config segment.bytes=351000000
bin/kafka-topics.sh --create --zookeeper $ZK_HOSTS --replication-factor 3 --partitions 3 --topic records --config retention.ms=21600000 --config retention.bytes=6318000000 --config segment.ms=3600000 --config segment.bytes=351000000
