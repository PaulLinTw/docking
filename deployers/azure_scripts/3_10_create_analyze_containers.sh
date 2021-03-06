source ./0_common_conf.sh

eval $(docker-machine env az-analyze1)

echo "create clustering container"
docker run -d --net=$overlay --name=clustering \
-v /home/$user/confs/ap.conf:/analyze/tester.conf \
$registry/demo/analyze:latest bash -c "python aptimer.py"

echo "create model_creator container"
docker run -d --net=$overlay --name=model_creator \
-v /home/$user/confs/ap.conf:/analyze/tester.conf \
$registry/demo/analyze:latest bash -c "python aptimer_model.py"

eval $(docker-machine env az-master)

echo "create model_loader container"
docker run -d --net=$overlay --name=model_loader \
-v /home/$user/confs/ap.conf:/app/tester.conf \
-v /home/$user/confs/app/aptimer_load.py:/app/aptimer_load.py \
-v /home/$user/ftp_zone/app/models:/models \
$registry/demo/portal:latest bash -c "cd /app && python aptimer_load.py"

echo "all client containers were created"
