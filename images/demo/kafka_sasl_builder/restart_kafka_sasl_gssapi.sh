Id="${1}"
cd /kafka/0.11.0.2/
export JMX_PORT=9041
export KAFKA_JMX_OPTS="-Djava.rmi.server.hostname=kafka$Id -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false "
export KAFKA_CLIENT_KERBEROS_PARAMS="-Djava.security.auth.login.config=/jaas/broker.jaas -Djava.security.krb5.conf=/etc/krb5.conf "
export KAFKA_OPTS="-Djava.security.auth.login.config=/jaas/broker.jaas -Djava.security.krb5.conf=/etc/krb5.conf -javaagent:/kafka/jmx_prometheus_javaagent-0.2.1-SNAPSHOT.jar=7071:/kafka/kafka-0-8-2.yml"
bin/kafka-server-start.sh config/server.properties.$Id
