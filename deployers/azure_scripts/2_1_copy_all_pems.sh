#/bin/bash!

copy_pem() {
name=$1
	sudo cp ~/.docker/machine/machines/$name/ca.pem ~/keys/azure/ca_$name.pem
	sudo cp ~/.docker/machine/machines/$name/cert.pem ~/keys/azure/cert_$name.pem
	sudo cp ~/.docker/machine/machines/$name/key.pem ~/keys/azure/key_$name.pem
}

copy_pem az-kvstore
copy_pem az-master
copy_pem az-worker1
copy_pem az-worker2
copy_pem az-worker3
copy_pem az-analyze1

sudo chown 1000.1000 ~/keys/azure/key_*.pem
sudo chmod +r ~/keys/azure/key_*.pem
