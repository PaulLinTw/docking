user="vagrant"

eval $(docker-machine env worker1)

echo "create act_sim_China container"
docker run -d --net=multi --name=act_sim_China \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py China"

echo "create act_sim_India container"
docker run -d --net=multi --name=act_sim_India \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py India"

echo "create act_sim_USA container"
docker run -d --net=multi --name=act_sim_USA \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py USA"

echo "create act_sim_Indonesia container"
docker run -d --net=multi --name=act_sim_Indonesia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py Indonesia"

eval $(docker-machine env worker2)

echo "create act_sim_Japan container"
docker run -d --net=multi --name=act_sim_Japan \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py Japan"

echo "create act_sim_UK container"
docker run -d --net=multi --name=act_sim_UK \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py UK"

echo "create act_sim_France container"
docker run -d --net=multi --name=act_sim_France \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py France"

echo "create act_sim_Germany container"
docker run -d --net=multi --name=act_sim_Germany \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py Germany"

eval $(docker-machine env worker3)

echo "create act_sim_Russia container"
docker run -d --net=multi --name=act_sim_Russia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py Russia"

echo "create act_sim_Mexico container"
docker run -d --net=multi --name=act_sim_Mexico \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_activity.py Mexico"

echo "create rec_sim_China container"
docker run -d --net=multi --name=rec_sim_China \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py China"

echo "create rec_sim_India container"
docker run -d --net=multi --name=rec_sim_India \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py India"

eval $(docker-machine env worker1)

echo "create rec_sim_USA container"
docker run -d --net=multi --name=rec_sim_USA \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py USA"

echo "create rec_sim_Indonesia container"
docker run -d --net=multi --name=rec_sim_Indonesia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py Indonesia"

echo "create rec_sim_Japan container"
docker run -d --net=multi --name=rec_sim_Japan \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py Japan"

eval $(docker-machine env worker2)

echo "create rec_sim_UK container"
docker run -d --net=multi --name=rec_sim_UK \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py UK"

echo "create rec_sim_France container"
docker run -d --net=multi --name=rec_sim_France \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py France"

echo "create rec_sim_Germany container"
docker run -d --net=multi --name=rec_sim_Germany \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py Germany"

eval $(docker-machine env worker3)

echo "create rec_sim_Russia container"
docker run -d --net=multi --name=rec_sim_Russia \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py Russia"

echo "create rec_sim_Mexico container"
docker run -d --net=multi --name=rec_sim_Mexico \
-v /home/$user/confs/ap.conf:/ap/tester.conf \
btgit.eastasia.cloudapp.azure.com:5000/demo/ap:latest 	bash -c "python simulate_record.py Mexico"

echo "all provider containers were created"
