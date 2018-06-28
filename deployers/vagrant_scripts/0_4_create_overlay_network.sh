#/bin/bash!

docker $(docker-machine config master1) network create \
    --driver overlay \
    --subnet=10.0.9.0/24 \
    multi
