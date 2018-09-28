#!/bin/bash
debug="-D"
overlay="multi"
with_elk=false
subnet="10.0.9.0"

# deploy_type has only two option: "azure","vagrant"
deploy_type="azure"
conf_from="azure"
if [ "$deploy_type" == "azure" ]; then
	group="az"
	export AZURE_SUBSCRIPTION_ID="12f2324c-9e69-476f-88c0-a92161643ca6"
	export AZURE_RESOURCE_GROUP="${group}"
	export AZURE_AVAILABILITY_SET="${group}-availability"
	export AZURE_VNET="${group}-vnet"
	export AZURE_SUBNET="default"
	export AZURE_IMAGE="OpenLogic:CentOS:7.3:latest"
	export AZURE_SUBNET_PREFIX="10.0.0.0/24"
	export AZURE_LOCATION="eastasia"
	export	AZURE_SSH_USER="azuser"

	registry="az-console:5000"
	user="azuser"
	DRIVER_NAME="azure"
	KVStore_Host="kvstore"
	Master_Host="master"
	ADVERTISE_INTERFACE="eth0"
	Options="--azure-no-public-ip"
else
	registry="192.168.1.103:5000"
	user="vagrant"
	DRIVER_NAME="generic"
	KVStore_Host="kvstore1"
	Master_Host="master1"
	ADVERTISE_INTERFACE="eth1"
	Options="--generic-ssh-key /home/$deployer/.ssh/id_rsa --generic-ssh-user vagrant"
	KVStore_IP="192.168.1.200"
	Master_IP= "192.168.1.201"
	Worker1_IP="192.168.1.202"
	Worker2_IP="192.168.1.203"
	Worker3_IP="192.168.1.204"
	Worker4_IP="192.168.1.205"
	Worker5_IP="192.168.1.206"
fi

Worker1_Host="worker1"
Worker2_Host="worker2"
Worker3_Host="worker3"
Worker4_Host="worker4"
Worker5_Host="worker5"
