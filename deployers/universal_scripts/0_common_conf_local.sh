#!/bin/bash
debug="-D"
overlay="poc"
with_elk=false
subnet="10.0.9.0"
aamode="_sasl_gssapi"

# deploy_type has only two option: "azure","vagrant"
deploy_type="generic"
conf_from="local"

registry="kvstore1:5000"
deployer="paul"
user="vagrant"
DRIVER_NAME="generic"
ADVERTISE_INTERFACE="eth1"
Options="--generic-ssh-key /home/$deployer/.ssh/id_rsa --generic-ssh-user vagrant"

KVStore_IP="192.168.56.200"
Master_IP="192.168.56.201"
Worker1_IP="192.168.56.202"
Worker2_IP="192.168.56.203"
Worker3_IP="192.168.56.204"
Worker4_IP="192.168.56.205"
Worker5_IP="192.168.56.206"

KVStore_Host="kvstore1"
Master_Host="master1"
Worker1_Host="worker1"
Worker2_Host="worker2"
Worker3_Host="worker3"
Worker4_Host="worker4"
Worker5_Host="worker5"

