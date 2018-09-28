#/bin/bash!

Id="${1}"
echo this ZKID = $Id 
echo "$Id" > var/zookeeper/myid
cat var/zookeeper/myid
cd 3.4.12/
export JMX_PORT=9031
export KAFKA_JMX_OPTS="-Djava.rmi.server.hostname=zk$Id -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false "
bin/zkServer.sh start-foreground conf/zookeeper.cfg.$Id
