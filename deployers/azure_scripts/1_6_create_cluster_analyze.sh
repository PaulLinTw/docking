source ./0_common_conf.sh

create_analyze(){
	id=$1
	kvip=$(docker-machine ip ${group}-kvstore)
	echo Creating cluster analyzes
	export AZURE_SIZE="Standard_A1"
	docker-machine $debug create --driver azure \
		--azure-no-public-ip \
		--swarm \
		--swarm-discovery="consul://${kvip}:8500" \
		--engine-insecure-registry $registry \
		--engine-opt="cluster-store=consul://${kvip}:8500" \
		--engine-opt="cluster-advertise=eth0:2376" \
		${group}-analyze${id}
}

create_analyze 1
