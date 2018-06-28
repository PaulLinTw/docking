source ./0_common_conf.sh

copy_pem() {
name=$1
	sudo cp ~/.docker/machine/machines/$name/ca.pem ~/keys/vm/ca_$name.pem
	sudo cp ~/.docker/machine/machines/$name/cert.pem ~/keys/vm/cert_$name.pem
	sudo cp ~/.docker/machine/machines/$name/key.pem ~/keys/vm/key_$name.pem
}

copy_pem $KV_Host
copy_pem $Master_Host
copy_pem $Worker1_Host
copy_pem $Worker2_Host
copy_pem $Worker3_Host

sudo chown 1000.1000 ~/keys/vm/key_*.pem
sudo chmod +r ~/keys/vm/key_*.pem
