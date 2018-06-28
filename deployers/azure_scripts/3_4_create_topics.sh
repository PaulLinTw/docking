echo switch to az-master swarm environment
eval $(docker-machine env --swarm az-master)

echo "create topics from kafka1"
docker exec kafka1 sh create_topics.sh

eval $(docker-machine env az-master)
echo "create grafana keys"
docker exec grafana bash /importer/create_key.sh

