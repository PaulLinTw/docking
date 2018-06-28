#/bin/bash!

eval $(docker-machine env az-master)
docker volume rm prometheusdata
docker volume rm grafanadata
docker volume rm $(docker volume ls -f name=mongo -q)

eval $(docker-machine env az-worker1)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)
docker volume rm $(docker volume ls -f name=mongo -q)

eval $(docker-machine env az-worker2)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)
docker volume rm $(docker volume ls -f name=mongo -q)

eval $(docker-machine env az-worker3)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)
docker volume rm $(docker volume ls -f name=mongo -q)

echo "all service volumes were removed."
