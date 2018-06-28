user="vagrant"

echo "create act_proc1 container"
eval $(docker-machine env worker1)
docker run -d --net=multi --name=act_proc1 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python process_activity.py"

echo "create act_proc2 container"
eval $(docker-machine env worker2)
docker run -d --net=multi --name=act_proc2 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python process_activity.py"

echo "create act_proc3 container"
eval $(docker-machine env worker3)
docker run -d --net=multi --name=act_proc3 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python process_activity.py"

sleep 5

echo "create rec_proc1 container"
eval $(docker-machine env worker1)
docker run -d --net=multi --name=rec_proc1 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python process_record.py"

echo "create rec_proc2 container"
eval $(docker-machine env worker2)
docker run -d --net=multi --name=rec_proc2 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python process_record.py"

echo "create rec_proc3 container"
eval $(docker-machine env worker3)
docker run -d --net=multi --name=rec_proc3 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python process_record.py"

sleep 5

echo "create act_store1 container"
eval $(docker-machine env worker1)
docker run -d --net=multi --name=act_store1 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python store_activity.py"

echo "create act_store2 container"
eval $(docker-machine env worker2)
docker run -d --net=multi --name=act_store2 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python store_activity.py"

echo "create act_store3 container"
eval $(docker-machine env worker3)
docker run -d --net=multi --name=act_store3 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python store_activity.py"

sleep 5

echo "create rec_store1 container"
eval $(docker-machine env worker1)
docker run -d --net=multi --name=rec_store1 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python store_record.py"

echo "create rec_store2 container"
eval $(docker-machine env worker2)
docker run -d --net=multi --name=rec_store2 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python store_record.py"

echo "create rec_store3 container"
eval $(docker-machine env worker3)
docker run -d --net=multi --name=rec_store3 \
--restart=always \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python store_record.py"

sleep 5

eval $(docker-machine env master1)

echo "create analyze container"
docker run -d --net=multi --name=analyze \
-v /home/$user/confs/ap.conf:/analyze/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/analyze:latest bash -c "python aptimer.py"

echo "create api container"
docker run -d --net=multi --name=api -p 19090:19090 \
-v /home/$user/confs/ap.conf:/analyze/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/analyze:latest bash -c "python demoapi.py 19090"

echo "create reporter container"
docker run -d --net=multi --name=reporter -p 9090:9090 \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest bash -c "python report.py 9090"

echo "all consumer containers were created"
