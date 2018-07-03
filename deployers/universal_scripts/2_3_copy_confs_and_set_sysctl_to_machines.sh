source ./0_common_conf.sh

docker-machine scp -r ../confs/ $Master_Host:.
docker-machine scp -r ../confs/ $Worker1_Host:.
docker-machine scp -r ../confs/ $Worker2_Host:.
docker-machine scp -r ../confs/ $Worker3_Host:.
docker-machine scp -r ../confs/ $Worker4_Host:.
docker-machine scp -r ../confs/ $Worker5_Host:.

docker-machine ssh $Master_Host chmod +r confs/
docker-machine ssh $Worker1_Host chmod +r confs/
docker-machine ssh $Worker2_Host chmod +r confs/
docker-machine ssh $Worker3_Host chmod +r confs/
docker-machine ssh $Worker4_Host chmod +r confs/
docker-machine ssh $Worker5_Host chmod +r confs/

docker-machine ssh $Master_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker1_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker2_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker3_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker4_Host sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh $Worker3_Host sudo sysctl -w net.ipv4.ip_forward=1

docker-machine ssh $Master_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker1_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker2_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker3_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker4_Host sudo sysctl -w vm.max_map_count=262144
docker-machine ssh $Worker5_Host sudo sysctl -w vm.max_map_count=262144

echo "all configurations were copied."
