#/bin/bash!

docker-machine ssh az-master   sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh az-worker1  sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh az-worker2  sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh az-worker3  sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh az-analyze1 sudo sysctl -w net.ipv4.ip_forward=1

docker-machine ssh az-master   sudo sysctl -w vm.max_map_count=262144
docker-machine ssh az-worker1  sudo sysctl -w vm.max_map_count=262144
docker-machine ssh az-worker2  sudo sysctl -w vm.max_map_count=262144
docker-machine ssh az-worker3  sudo sysctl -w vm.max_map_count=262144
docker-machine ssh az-analyze1 sudo sysctl -w vm.max_map_count=262144

echo "all host sysctl were set."
