#/bin/bash!
cd ~/images/demo
sh build_demo.sh
cd ~/images/demo
sh push_demo.sh
cd ~/images/elk-x-pack
#cd ~/images/elk_630
sh build_elk.sh
sh push_elk.sh

