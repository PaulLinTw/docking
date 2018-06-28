#/bin/bash!

eval $(docker-machine env master1)
docker volume rm prometheusdata
docker volume rm grafanadata
docker volume rm $(docker volume ls -f name=mongo -q)

eval $(docker-machine env worker1)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)

eval $(docker-machine env worker2)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)

eval $(docker-machine env worker3)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)

echo "all service volumes were removed."
