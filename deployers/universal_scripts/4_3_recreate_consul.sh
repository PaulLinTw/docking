source ./0_common_conf.sh

read -p "Do you want to recreate consul?(yes|no)" ans
if [[ $ans == "yes" ]] ;then
	docker $(docker-machine config $KVStore_Host) rm consul -f
	docker $(docker-machine config $KVStore_Host) run -d -p "8500:8500" --name consul progrium/consul --server -bootstrap-expect 1
	sleep 20
fi
