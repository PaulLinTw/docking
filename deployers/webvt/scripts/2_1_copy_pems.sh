source ./0_common_conf.sh
mkdir -p ~/keys/webvt/$deploy_type
copy_pem() {
name=$1
	sudo cp ~/.docker/machine/machines/$name/ca.pem ~/keys/webvt/$deploy_type/ca_$name.pem
	sudo cp ~/.docker/machine/machines/$name/cert.pem ~/keys/webvt/$deploy_type/cert_$name.pem
	sudo cp ~/.docker/machine/machines/$name/key.pem ~/keys/webvt/$deploy_type/key_$name.pem
}

copy_pem $WebVT_Host

sudo chown 1000.1000 ~/keys/webvt/$deploy_type/key_*.pem
sudo chmod +r ~/keys/webvt/$deploy_type/key_*.pem
