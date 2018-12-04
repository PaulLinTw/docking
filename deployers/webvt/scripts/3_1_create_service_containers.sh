source ./0_common_conf.sh

eval $(docker-machine env $WebVT_Host)

echo "create WebVT container"
docker run -d --net=$overlay --name=webvt -p 5050:5050 \
-v /home/$user/confs/ap.conf:/app/tester.conf \
-v /home/$user/confs/app/app.py:/app/app.py \
-v /home/$user/confs/app/base/models.py:/app/base/models.py \
-v /home/$user/confs/app/base/routes.py:/app/base/routes.py \
-v /home/$user/confs/app/base/templates/:/app/base/templates/ \
-v /home/$user/confs/app/extends/:/app/extends/ \
-v /home/$user/confs/app/dashboards/:/app/dashboards/ \
-v /home/$user/confs/app/countries/:/app/countries/ \
-v /home/$user/confs/app/products/:/app/products/ \
-v /home/$user/confs/app/actions/:/app/actions/ \
-v /home/$user/confs/app/visits/:/app/visits/ \
-v /home/$user/confs/app/abouts/:/app/abouts/ \
$registry/demo/portal:latest

echo "all service containers were created. please check clusters by portainer"
