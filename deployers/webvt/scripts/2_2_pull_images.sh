source ./0_common_conf.sh

eval $(docker-machine env $WebVT_Host)
docker pull $registry/demo/portal
