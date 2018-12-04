create_webvt() {
	echo "Creating webvt machine."

	if [ "$deploy_type" == "azure" ]; then
		export AZURE_SIZE="Standard_A0"
	elif [ "$deploy_type" == "gcp" ]; then
		export GCP_SIZE="Standard_A0"
	elif [ "$deploy_type" == "aws" ]; then
		export AWS_SIZE="Standard_A0"
	elif [ "$deploy_type" == "generic" ]; then
		ip=$1
		ssh-copy-id -f -i ~/.ssh/id_rsa.pub $user@${ip}
		Options="--generic-ip-address ${ip} ${Options}"
	else
		echo "Invalid deploy_type \"$deploy_type\"."
		exit 1
	fi
	docker-machine $debug create --driver $DRIVER_NAME \
		$Options \
		$WebVT_Host
}
