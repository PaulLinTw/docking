#/bin/bash!

docker-machine ssh az-master   sudo rm -rf ./confs
docker-machine ssh az-worker1  sudo rm -rf ./confs
docker-machine ssh az-worker2  sudo rm -rf ./confs
docker-machine ssh az-worker3  sudo rm -rf ./confs
docker-machine ssh az-analyze1 sudo rm -rf ./confs

docker-machine scp -r confs/ az-master:.
docker-machine scp -r confs/ az-worker1:.
docker-machine scp -r confs/ az-worker2:.
docker-machine scp -r confs/ az-worker3:.
docker-machine scp -r confs/ az-analyze1:.

docker-machine ssh az-master   chmod +r confs/
docker-machine ssh az-worker1  chmod +r confs/
docker-machine ssh az-worker2  chmod +r confs/
docker-machine ssh az-worker3  chmod +r confs/
docker-machine ssh az-analyze1 chmod +r confs/

echo "all configurations were copied."
