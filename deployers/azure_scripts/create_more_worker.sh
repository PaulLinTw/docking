#!/bin/bash
# This script helps to create a develop docker swarm cluster in one command
# For explanations and details, please refer to:
# https://docs.docker.com/engine/userguide/networking/get-started-overlay/

registry="btgit.eastasia.cloudapp.azure.com:5000"
debug="-D"
group="az"

export AZURE_SIZE="Standard_A2"
export AZURE_SUBSCRIPTION_ID="12f2324c-9e69-476f-88c0-a92161643ca6"
export AZURE_RESOURCE_GROUP="$group"
export AZURE_AVAILABILITY_SET="${group}-availability"
export AZURE_VNET="${group}-vnet"
export AZURE_SUBNET="default"
export AZURE_IMAGE="OpenLogic:CentOS:7.3:latest"
export AZURE_SUBNET_PREFIX="10.0.0.0/24"
export AZURE_LOCATION="eastasia"
export	AZURE_SSH_USER="azuser"
set -e

id=$1
echo Creating cluster worker$id

kvip=$(docker-machine ip ${group}-kvstore)
docker-machine $debug create --driver azure \
	--azure-no-public-ip \
	--swarm \
	--swarm-discovery="consul://${kvip}:8500" \
	--engine-insecure-registry $registry \
	--engine-opt="cluster-store=consul://${kvip}:8500" \
	--engine-opt="cluster-advertise=eth0:2376" \
	${group}-worker$id
