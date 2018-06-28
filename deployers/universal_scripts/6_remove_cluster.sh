source ./0_common_conf.sh

docker-machine -D rm $KVStore_Host  -f
docker-machine -D rm $Master_Host   -f
docker-machine -D rm $Worker1_Host  -f
docker-machine -D rm $Worker2_Host  -f
docker-machine -D rm $Worker3_Host  -f
