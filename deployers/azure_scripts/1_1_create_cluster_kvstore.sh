source ./0_common_conf.sh

create_kv() {

	echo "Creating ${group}-kvstore machine."
	export AZURE_SIZE="Standard_A0"

	docker-machine $debug create --driver azure \
		--azure-no-public-ip \
		${group}-kvstore

	docker $(docker-machine config ${group}-kvstore) run -d \
		-p "8500:8500" \
		--name consul \
		progrium/consul --server -bootstrap-expect 1
}

create_kv
