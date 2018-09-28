source ./0_common_conf.sh

: <<'END'

echo "create act_proc1 container"
eval $(docker-machine env $Worker1_Host)
docker run -d --net=$overlay --name=act_proc1 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python process_activity.py"

echo "create act_proc2 container"
eval $(docker-machine env $Worker2_Host)
docker run -d --net=$overlay --name=act_proc2 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python process_activity.py"

echo "create act_proc3 container"
eval $(docker-machine env $Worker3_Host)
docker run -d --net=$overlay --name=act_proc3 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python process_activity.py"

sleep 5

echo "create rec_proc1 container"
eval $(docker-machine env $Worker1_Host)
docker run -d --net=$overlay --name=rec_proc1 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python process_record.py"

echo "create rec_proc2 container"
eval $(docker-machine env $Worker2_Host)
docker run -d --net=$overlay --name=rec_proc2 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python process_record.py"

echo "create rec_proc3 container"
eval $(docker-machine env $Worker3_Host)
docker run -d --net=$overlay --name=rec_proc3 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python process_record.py"

sleep 5

END

echo "create act_store1 container"
eval $(docker-machine env $Worker1_Host)
docker run -d --net=$overlay --name=act_store1 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_activity.py"

eval $(docker-machine env $Worker2_Host)
echo "create act_store2 container"
docker run -d --net=$overlay --name=act_store2 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_activity.py"

eval $(docker-machine env $Worker3_Host)
echo "create act_store3 container"
docker run -d --net=$overlay --name=act_store3 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_activity.py"

sleep 5

echo "create rec_store1 container"
eval $(docker-machine env $Worker1_Host)
docker run -d --net=$overlay --name=rec_store1 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_record.py"

echo "create rec_store2 container"
eval $(docker-machine env $Worker2_Host)
docker run -d --net=$overlay --name=rec_store2 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_record.py"

echo "create rec_store3 container"
eval $(docker-machine env $Worker3_Host)
docker run -d --net=$overlay --name=rec_store3 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest bash -c "python store_record.py"

echo "all consumer containers were created"
