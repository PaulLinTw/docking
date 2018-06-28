#/bin/bash!

docker-machine ssh master1 sudo cp /dev/null /var/lib/docker/volumes/mongodb_router/_data/router.log
docker-machine ssh worker1 sh confs/clear_logs.sh
docker-machine ssh worker2 sh confs/clear_logs.sh
docker-machine ssh worker3 sh confs/clear_logs.sh

echo "all mongodb logs were cleared."
