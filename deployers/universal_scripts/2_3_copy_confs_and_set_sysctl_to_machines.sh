source ./0_common_conf.sh

docker-machine ssh $Master_Host sudo rm -rf confs
docker-machine ssh $Worker1_Host sudo rm -rf confs
docker-machine ssh $Worker2_Host sudo rm -rf confs
docker-machine ssh $Worker3_Host sudo rm -rf confs

docker-machine scp -r ../configs/$conf_from/confs $Master_Host:.
docker-machine scp -r ../configs/$conf_from/confs $Worker1_Host:.
docker-machine scp -r ../configs/$conf_from/confs $Worker2_Host:.
docker-machine scp -r ../configs/$conf_from/confs $Worker3_Host:.

docker-machine ssh $Master_Host chmod +r confs/
docker-machine ssh $Worker1_Host chmod +r confs/
docker-machine ssh $Worker2_Host chmod +r confs/
docker-machine ssh $Worker3_Host chmod +r confs/

docker-machine ssh $Master_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker1_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker2_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker3_Host sudo sysctl -w net.ipv4.ip_forward=1

docker-machine ssh $Master_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker1_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker2_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker3_Host sudo sysctl -w vm.max_map_count=262144

echo "all configurations were copied."
