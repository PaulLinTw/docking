#/bin/bash!

docker-machine ssh az-master sudo cp /dev/null /var/lib/docker/volumes/mongodb_router/_data/router.log
docker-machine ssh az-worker1 sh confs/clear_logs.sh
docker-machine ssh az-worker2 sh confs/clear_logs.sh
docker-machine ssh az-worker3 sh confs/clear_logs.sh

echo "all logs were cleared."
