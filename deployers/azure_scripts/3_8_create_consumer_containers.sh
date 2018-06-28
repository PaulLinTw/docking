source ./0_common_conf.sh

echo "ignore act_proc and rec_proc to redis"
: <<'END'

eval $(docker-machine env az-worker1)
echo "create act_proc1 container"
docker run -d --net=$overlay --name=act_proc1 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python process_activity.py"

eval $(docker-machine env az-worker2)
echo "create act_proc2 container"
docker run -d --net=$overlay --name=act_proc2 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python process_activity.py"

eval $(docker-machine env az-worker3)
echo "create act_proc3 container"
docker run -d --net=$overlay --name=act_proc3 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python process_activity.py"

sleep 3

eval $(docker-machine env az-worker1)
echo "create rec_proc1 container"
docker run -d --net=$overlay --name=rec_proc1 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python process_record.py"

eval $(docker-machine env az-worker2)
echo "create rec_proc2 container"
docker run -d --net=$overlay --name=rec_proc2 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python process_record.py"

eval $(docker-machine env az-worker3)
echo "create rec_proc3 container"
docker run -d --net=$overlay --name=rec_proc3 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python process_record.py"

sleep 5

END

echo "create act_store1 container"
eval $(docker-machine env az-worker1)
docker run -d --net=$overlay --name=act_store1 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_activity.py"

echo "create act_store2 container"
eval $(docker-machine env az-worker2)
docker run -d --net=$overlay --name=act_store2 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_activity.py"

echo "create act_store3 container"
eval $(docker-machine env az-worker3)
docker run -d --net=$overlay --name=act_store3 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_activity.py"

sleep 5

echo "create rec_store1 container"
eval $(docker-machine env az-worker1)
docker run -d --net=$overlay --name=rec_store1 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_record.py"

echo "create rec_store2 container"
eval $(docker-machine env az-worker2)
docker run -d --net=$overlay --name=rec_store2 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_record.py"

echo "create rec_store3 container"
eval $(docker-machine env az-worker3)
docker run -d --net=$overlay --name=rec_store3 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_record.py"

echo "all client containers were created"
