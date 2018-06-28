#/bin/bash!

sudo kill nginx
sudo cp az_demo.conf /etc/nginx/conf.d/
sudo nginx
