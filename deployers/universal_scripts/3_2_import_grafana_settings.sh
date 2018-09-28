source ./0_common_conf.sh

eval $(docker-machine env $Master_Host)

echo "Import grafana settings"
docker exec grafana bash /importer/create_key.sh

echo "grafana settings imported."
