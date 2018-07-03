source ./0_common_conf.sh

eval $(docker-machine env $Worker4_Host)

echo "create act_sim_China container"
docker run -d --net=$overlay --name=act_sim_China \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py China"

echo "create act_sim_India container"
docker run -d --net=$overlay --name=act_sim_India \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py India"

echo "create act_sim_USA container"
docker run -d --net=$overlay --name=act_sim_USA \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py USA"

echo "create act_sim_Indonesia container"
docker run -d --net=$overlay --name=act_sim_Indonesia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Indonesia"

echo "create act_sim_Japan container"
docker run -d --net=$overlay --name=act_sim_Japan \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Japan"

echo "create act_sim_UK container"
docker run -d --net=$overlay --name=act_sim_UK \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py UK"

echo "create act_sim_France container"
docker run -d --net=$overlay --name=act_sim_France \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py France"

echo "create act_sim_Germany container"
docker run -d --net=$overlay --name=act_sim_Germany \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Germany"

echo "create act_sim_Russia container"
docker run -d --net=$overlay --name=act_sim_Russia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Russia"

echo "create act_sim_Mexico container"
docker run -d --net=$overlay --name=act_sim_Mexico \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_activity.py Mexico"

eval $(docker-machine env $Worker5_Host)

echo "create rec_sim_China container"
docker run -d --net=$overlay --name=rec_sim_China \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py China"

echo "create rec_sim_India container"
docker run -d --net=$overlay --name=rec_sim_India \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py India"

echo "create rec_sim_USA container"
docker run -d --net=$overlay --name=rec_sim_USA \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py USA"

echo "create rec_sim_Indonesia container"
docker run -d --net=$overlay --name=rec_sim_Indonesia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Indonesia"

echo "create rec_sim_Japan container"
docker run -d --net=$overlay --name=rec_sim_Japan \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Japan"

echo "create rec_sim_UK container"
docker run -d --net=$overlay --name=rec_sim_UK \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py UK"

echo "create rec_sim_France container"
docker run -d --net=$overlay --name=rec_sim_France \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py France"

echo "create rec_sim_Germany container"
docker run -d --net=$overlay --name=rec_sim_Germany \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Germany"

echo "create rec_sim_Russia container"
docker run -d --net=$overlay --name=rec_sim_Russia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Russia"

echo "create rec_sim_Mexico container"
docker run -d --net=$overlay --name=rec_sim_Mexico \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
$registry/demo/ap:latest 	bash -c "python simulate_record.py Mexico"

echo "all provider containers were created"
