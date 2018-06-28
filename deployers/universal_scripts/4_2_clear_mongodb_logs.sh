source ./0_common_conf.sh

docker-machine ssh $Master_Host sudo cp /dev/null /var/lib/docker/volumes/mongodb_router/_data/router.log
docker-machine ssh $Worker1_Host sh confs/clear_logs.sh
docker-machine ssh $Worker2_Host sh confs/clear_logs.sh
docker-machine ssh $Worker3_Host sh confs/clear_logs.sh

echo "all mongodb logs were cleared."
