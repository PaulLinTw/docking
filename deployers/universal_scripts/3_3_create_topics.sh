source ./0_common_conf.sh
eval $(docker-machine env --swarm $Master_Host)

echo "create topics from kafka1"
docker exec kafka1 sh create_topics.sh
