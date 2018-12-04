#!/bin/bash

debug="-D"
deploy_type="generic"

registry="192.168.1.103:5000"
deployer="paul"
user="vagrant"
DRIVER_NAME="generic"
ADVERTISE_INTERFACE="eth1"

WebVT_IP="192.168.56.111"

WebVT_Host="web1"

Options="--generic-ssh-key /home/$deployer/.ssh/id_rsa --generic-ssh-user $user"

