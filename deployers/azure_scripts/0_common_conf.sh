#!/bin/bash
registry="az-console:5000"
debug="-D"
group="az"
overlay="multi"
user="azuser"

export AZURE_SUBSCRIPTION_ID="12f2324c-9e69-476f-88c0-a92161643ca6"
export AZURE_RESOURCE_GROUP="$group"
export AZURE_AVAILABILITY_SET="${group}-availability"
export AZURE_VNET="${group}-vnet"
export AZURE_SUBNET="default"
export AZURE_IMAGE="OpenLogic:CentOS:7.3:latest"
export AZURE_SUBNET_PREFIX="10.0.0.0/24"
export AZURE_LOCATION="eastasia"
export	AZURE_SSH_USER="azuser"

