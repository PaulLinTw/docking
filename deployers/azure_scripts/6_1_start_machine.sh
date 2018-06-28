#!/bin/bash
group="az"
docker-machine start $group-kvstore
docker $(docker-machine config $group-kvstore) start consul
docker-machine start $group-master
docker-machine start $(docker-machine ls --filter name=$group-worker -q)
docker-machine start $(docker-machine ls --filter name=$group-analyze -q)
