source ./0_common_conf.sh

eval $(docker-machine env az-master)
echo "create act_sim_China container"
docker run -d --net=$overlay --name=act_sim_China \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py China 600"

eval $(docker-machine env az-worker1)
echo "create act_sim_India container"
docker run -d --net=$overlay --name=act_sim_India \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py India 350"

eval $(docker-machine env az-worker2)
echo "create act_sim_USA container"
docker run -d --net=$overlay --name=act_sim_USA \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py USA 400"

eval $(docker-machine env az-worker3)
echo "create act_sim_Indonesia container"
docker run -d --net=$overlay --name=act_sim_Indonesia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Indonesia 120"

eval $(docker-machine env az-master)
echo "create act_sim_Japan container"
docker run -d --net=$overlay --name=act_sim_Japan \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Japan 160"

eval $(docker-machine env az-worker1)
echo "create act_sim_UK container"
docker run -d --net=$overlay --name=act_sim_UK \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py UK 120"

eval $(docker-machine env az-worker2)
echo "create act_sim_France container"
docker run -d --net=$overlay --name=act_sim_France \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py France 160"

eval $(docker-machine env az-worker3)
echo "create act_sim_Germany container"
docker run -d --net=$overlay --name=act_sim_Germany \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Germany 240"

eval $(docker-machine env az-master)
echo "create act_sim_Russia container"
docker run -d --net=$overlay --name=act_sim_Russia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Russia 250"

eval $(docker-machine env az-worker1)
echo "create act_sim_Mexico container"
docker run -d --net=$overlay --name=act_sim_Mexico \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Mexico 80"

eval $(docker-machine env az-worker2)
echo "create rec_sim_China container"
docker run -d --net=$overlay --name=rec_sim_China \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py China 450"

eval $(docker-machine env az-worker3)
echo "create rec_sim_India container"
docker run -d --net=$overlay --name=rec_sim_India \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py India 320"

eval $(docker-machine env az-master)
echo "create rec_sim_USA container"
docker run -d --net=$overlay --name=rec_sim_USA \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py USA 300"

eval $(docker-machine env az-worker1)
echo "create rec_sim_Indonesia container"
docker run -d --net=$overlay --name=rec_sim_Indonesia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Indonesia 120"

eval $(docker-machine env az-worker2)
echo "create rec_sim_Japan container"
docker run -d --net=$overlay --name=rec_sim_Japan \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Japan 160"

eval $(docker-machine env az-worker3)
echo "create rec_sim_UK container"
docker run -d --net=$overlay --name=rec_sim_UK \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py UK 120"

eval $(docker-machine env az-master)
echo "create rec_sim_France container"
docker run -d --net=$overlay --name=rec_sim_France \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py France 160"

eval $(docker-machine env az-worker1)
echo "create rec_sim_Germany container"
docker run -d --net=$overlay --name=rec_sim_Germany \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Germany 240"

eval $(docker-machine env az-worker2)
echo "create rec_sim_Russia container"
docker run -d --net=$overlay --name=rec_sim_Russia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Russia 210"

eval $(docker-machine env az-worker3)
echo "create rec_sim_Mexico container"
docker run -d --net=$overlay --name=rec_sim_Mexico \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Mexico 80"

echo "all client containers were created"
