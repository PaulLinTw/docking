source ./0_common_conf.sh

create_worker(){
	id=$1
	kvip=$(docker-machine ip ${group}-kvstore)
	echo Creating cluster workers
	export AZURE_SIZE="Standard_A2"
	docker-machine $debug create --driver azure \
		--azure-no-public-ip \
		--swarm \
		--swarm-discovery="consul://${kvip}:8500" \
		--engine-insecure-registry $registry \
		--engine-opt="cluster-store=consul://${kvip}:8500" \
		--engine-opt="cluster-advertise=eth0:2376" \
		${group}-worker${id}
}

create_worker 2
