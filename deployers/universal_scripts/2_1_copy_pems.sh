source ./0_common_conf.sh
mkdir -p ~/keys/$deploy_type
copy_pem() {
name=$1
	sudo cp ~/.docker/machine/machines/$name/ca.pem ~/keys/$deploy_type/ca_$name.pem
	sudo cp ~/.docker/machine/machines/$name/cert.pem ~/keys/$deploy_type/cert_$name.pem
	sudo cp ~/.docker/machine/machines/$name/key.pem ~/keys/$deploy_type/key_$name.pem
}

copy_pem $KVStore_Host
copy_pem $Master_Host
copy_pem $Worker1_Host
copy_pem $Worker2_Host
copy_pem $Worker3_Host
copy_pem $Worker4_Host
copy_pem $Worker5_Host

sudo chown 1000.1000 ~/keys/$deploy_type/key_*.pem
sudo chmod +r ~/keys/$deploy_type/key_*.pem
