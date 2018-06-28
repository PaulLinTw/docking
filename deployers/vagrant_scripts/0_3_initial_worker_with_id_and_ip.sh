#/bin/bash!

id=$1
ip=$2

registry="btgit.eastasia.cloudapp.azure.com:5000"

kvip=$(docker-machine ip kvstore1)

ssh-copy-id -i ~/keys/vagrant.pub vagrant@${ip}
docker-machine -D create -d generic --generic-ip-address ${ip} \
	--generic-ssh-key ~/keys/vagrant \
	--generic-ssh-user vagrant \
	--swarm \
	--swarm-discovery="consul://${kvip}:8500" \
	--engine-insecure-registry $registry \
	--engine-opt="cluster-store=consul://${kvip}:8500" \
	--engine-opt="cluster-advertise=eth1:2376" \
	worker$id
