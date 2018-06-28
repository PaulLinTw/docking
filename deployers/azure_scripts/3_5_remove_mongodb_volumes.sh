#/bin/bash!
eval $(docker-machine env --swarm az-master)
docker volume rm $(docker volume ls -f name=mongo -q)

echo "all mongodb volumes were created."
