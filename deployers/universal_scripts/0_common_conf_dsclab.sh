#!/bin/bash
echo "configuration tag: dsclab"
debug="-D"
overlay="dsclab"
with_elk=false
subnet="10.0.9.0"

deploy_type="generic"
conf_from="dsclab"

registry="192.168.1.103:5000"
deployer="paul"
user="vagrant"
DRIVER_NAME="generic"
ADVERTISE_INTERFACE="eth1"

KVStore_IP="192.168.1.200"
 Master_IP="192.168.1.201"
Worker1_IP="192.168.1.202"
Worker2_IP="192.168.1.203"
Worker3_IP="192.168.1.204"
Worker4_IP="192.168.1.205"
Worker5_IP="192.168.1.206"

KVStore_Host="kvstore1"
 Master_Host="master1"
Worker1_Host="worker1"
Worker2_Host="worker2"
Worker3_Host="worker3"
Worker4_Host="worker4"
Worker5_Host="worker5"

Options="--generic-ssh-key /home/$deployer/.ssh/id_rsa --generic-ssh-user $user"

