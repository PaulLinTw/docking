echo switch to az-master swarm environment
eval $(docker-machine env --swarm master1)

echo "create topics from kafka1"
docker exec kafka1 sh create_topics.sh
