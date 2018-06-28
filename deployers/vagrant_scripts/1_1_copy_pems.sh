#/bin/bash!

copy_pem() {
name=$1
	sudo cp ~/.docker/machine/machines/$name/ca.pem ~/keys/vm/ca_$name.pem
	sudo cp ~/.docker/machine/machines/$name/cert.pem ~/keys/vm/cert_$name.pem
	sudo cp ~/.docker/machine/machines/$name/key.pem ~/keys/vm/key_$name.pem
}

copy_pem kvstore1
copy_pem master1
copy_pem worker1
copy_pem worker2
copy_pem worker3

sudo chown 1000.1000 ~/keys/vm/key_*.pem
sudo chmod +r ~/keys/vm/key_*.pem
