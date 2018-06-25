#/bin/bash!
cd ~/images/demo
sh build_demo.sh
cd ~/images/demo
sh push_demo.sh
cd ~/images/elk-x-pack
sh build_elk.sh
cd ~/images/elk-x-pack
sh push_elk.sh

