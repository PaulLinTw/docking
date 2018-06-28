source ./0_common_conf.sh

registry="btgit.eastasia.cloudapp.azure.com:5000"

ip="192.168.1.200"
ssh-copy-id -i ~/keys/vagrant.pub vagrant@${ip}
docker-machine -D create -d generic --generic-ip-address ${ip} \
	--generic-ssh-key ~/keys/vagrant \
	--generic-ssh-user vagrant \
	kvstore1
docker $(docker-machine config kvstore1) run -d \
	-p "8500:8500" \
	--name consul \
	progrium/consul --server -bootstrap-expect 1

