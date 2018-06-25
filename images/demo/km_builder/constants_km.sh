#!/bin/bash

export ZK_HOSTS="172.17.0.6:2181,172.17.0.7:2181,172.17.0.8:2181"
export KAFKA_MANAGER_AUTH_ENABLED=true
export KAFKA_MANAGER_USERNAME="kmuser"
export KAFKA_MANAGER_PASSWORD="usekm"
#export CONSUMER_PROPERTIES_FILE="conf/consumer.properties"

function colortext(){
	echo -e "\e[33m$1\e[0m"
}
colortext "*************** LIST OF VARIABLES ***************"
colortext "Export: ZK_HOSTS=$ZK_HOSTS"
colortext "        KAFKA_MANAGER_AUTH_ENABLED=$KAFKA_MANAGER_AUTH_ENABLED"
colortext "        KAFKA_MANAGER_USERNAME=$KAFKA_MANAGER_USERNAME"
colortext "        KAFKA_MANAGER_PASSWORD=$KAFKA_MANAGER_PASSWORD"
colortext "****************** END OF LIST ******************"
