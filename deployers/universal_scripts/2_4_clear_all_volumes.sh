source ./0_common_conf.sh

eval $(docker-machine env --swarm $Master_Host)

#eval $(docker-machine env master1)
docker volume rm prometheusdata
docker volume rm grafanadata
docker volume rm $(docker volume ls -f name=mongo -q)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafka -q)
docker volume rm $(docker volume ls -f name=esdata -q)
docker volume rm $(docker volume ls -f name=redisdata -q)

: << END
#eval $(docker-machine env worker1)
#eval $(docker-machine env worker2)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)

#eval $(docker-machine env worker3)
docker volume rm $(docker volume ls -f name=zkdata -q)
docker volume rm $(docker volume ls -f name=kafkadata -q)
docker volume rm $(docker volume ls -f name=esdata -q)
END

echo "all service volumes were removed."
