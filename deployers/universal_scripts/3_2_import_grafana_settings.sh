source ./0_common_conf.sh

eval $(docker-machine env $Master_Host)

echo "Import grafana settings"
docker exec grafana sh /importer/create_key.sh

echo "grafana settings imported."
