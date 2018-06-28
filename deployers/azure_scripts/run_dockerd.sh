#/bin/bash!
sudo kill dockerd
echo run docker with unix.sock and port 2375 
sudo dockerd --insecure-registry az-console:5000 -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375 &
