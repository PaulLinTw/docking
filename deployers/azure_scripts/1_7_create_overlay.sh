source ./0_common_conf.sh

create_overlay(){
    docker $(docker-machine config ${group}-master) network create \
        --driver overlay \
        --subnet=10.0.9.0/24 \
        $overlay
}

create_overlay
