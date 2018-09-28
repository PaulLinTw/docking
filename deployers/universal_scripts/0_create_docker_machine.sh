create_kv() {
	echo "Creating kvstore machine."

	if [ "$deploy_type" == "azure" ]; then
		export AZURE_SIZE="Standard_A0"
	elif [ "$deploy_type" == "gcp" ]; then
		export GCP_SIZE="Standard_A0"
	elif [ "$deploy_type" == "aws" ]; then
		export AWS_SIZE="Standard_A0"
	elif [ "$deploy_type" == "generic" ]; then
		ip=$1
		ssh-copy-id -f -i ~/.ssh/id_rsa.pub $user@${ip}
		Options="--generic-ip-address ${ip} ${Options}"
	else
		echo "Invalid deploy_type \"$deploy_type\"."
		exit 1
	fi
	docker-machine $debug create --driver $DRIVER_NAME \
		$Options \
		$KVStore_Host

	docker $(docker-machine config $KVStore_Host) run -d \
		-p "8500:8500" \
		--name consul \
		progrium/consul --server -bootstrap-expect 1
}

create_master() {

	echo "Creating cluster master"
	if [ "$deploy_type" == "azure" ]; then
		export AZURE_SIZE="Standard_A4"
	elif [ "$deploy_type" == "gcp" ]; then
		export GCP_SIZE="Standard_A0"
	elif [ "$deploy_type" == "aws" ]; then
		export AWS_SIZE="Standard_A0"
	elif [ "$deploy_type" == "generic" ]; then
		ip=$1
		ssh-copy-id -i ~/.ssh/id_rsa.pub $user@${ip}
		Options="--generic-ip-address ${ip} ${Options}"
	else
		echo "Invalid deploy_type \"$deploy_type\"."
		exit 1
	fi

	kvip=$(docker-machine ip $KVStore_Host)

	docker-machine $debug create --driver $DRIVER_NAME \
		$Options \
		--swarm --swarm-master \
		--swarm-discovery="consul://${kvip}:8500" \
		--engine-insecure-registry $registry \
		--engine-opt="cluster-store=consul://${kvip}:8500" \
		--engine-opt="cluster-advertise=${ADVERTISE_INTERFACE}:2376" \
		$Master_Host
}

create_worker(){
	worker_name=$1
	echo "Creating cluster node ${worker_name}"
	if [ "$deploy_type" == "azure" ]; then
		export AZURE_SIZE="Standard_A8"
	elif [ "$deploy_type" == "gcp" ]; then
		export GCP_SIZE="Standard_A0"
	elif [ "$deploy_type" == "aws" ]; then
		export AWS_SIZE="Standard_A0"
	elif [ "$deploy_type" == "generic" ]; then
		ip=$2
		ssh-copy-id -i ~/.ssh/id_rsa.pub $user@${ip}
		Options="--generic-ip-address ${ip} ${Options}"
	else
		echo "Invalid deploy_type \"$deploy_type\"."
		exit 1
	fi

	kvip=$(docker-machine ip $KVStore_Host)

	docker-machine $debug create --driver $DRIVER_NAME \
		$Options \
		--swarm \
		--swarm-discovery="consul://${kvip}:8500" \
		--engine-insecure-registry $registry \
		--engine-opt="cluster-store=consul://${kvip}:8500" \
		--engine-opt="cluster-advertise=${ADVERTISE_INTERFACE}:2376" \
		${worker_name}
}
