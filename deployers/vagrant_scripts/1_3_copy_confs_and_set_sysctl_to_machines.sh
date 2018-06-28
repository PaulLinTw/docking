#/bin/bash!

docker-machine scp -r ../confs/ master1:.
docker-machine scp -r ../confs/ worker1:.
docker-machine scp -r ../confs/ worker2:.
docker-machine scp -r ../confs/ worker3:.

docker-machine ssh master1 chmod +r confs/
docker-machine ssh worker1 chmod +r confs/
docker-machine ssh worker2 chmod +r confs/
docker-machine ssh worker3 chmod +r confs/

docker-machine ssh master1 sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh worker1 sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh worker2 sudo sysctl -w net.ipv4.ip_forward=1
docker-machine ssh worker3 sudo sysctl -w net.ipv4.ip_forward=1

docker-machine ssh master1 sudo sysctl -w vm.max_map_count=262144
docker-machine ssh worker1 sudo sysctl -w vm.max_map_count=262144
docker-machine ssh worker2 sudo sysctl -w vm.max_map_count=262144
docker-machine ssh worker3 sudo sysctl -w vm.max_map_count=262144

echo "all configurations were copied."
