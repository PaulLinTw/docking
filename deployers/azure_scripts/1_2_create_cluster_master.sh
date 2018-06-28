source ./0_common_conf.sh

create_master() {
	echo Creating cluster master
	export AZURE_SIZE="Standard_A1"

	kvip=$(docker-machine ip ${group}-kvstore)

	docker-machine $debug create --driver azure \
		--azure-no-public-ip \
		--swarm --swarm-master \
		--swarm-discovery="consul://${kvip}:8500" \
		--engine-insecure-registry $registry \
		--engine-opt="cluster-store=consul://${kvip}:8500" \
		--engine-opt="cluster-advertise=eth0:2376" \
		${group}-master
}
create_master 

