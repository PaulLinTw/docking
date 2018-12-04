source ./0_common_conf.sh

docker-machine ssh $WebVT_Host sudo rm -rf confs

docker-machine scp -r ../confs $WebVT_Host:.

docker-machine ssh $WebVT_Host chmod +r confs/

docker-machine ssh $WebVT_Host sudo sysctl -w net.ipv4.ip_forward=1

docker-machine ssh $WebVT_Host sudo sysctl -w vm.max_map_count=262144

echo "all configurations were copied."
