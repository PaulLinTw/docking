#/bin/bash!
user="vagrant"
eval $(docker-machine env master1)

docker exec mongos bash -c "sh initiate_db.sh"

sleep 3
dqt='"'
echo "create count_activity container"
docker run -d --net=multi --name=count_activity \
--restart=always \
-v /home/$user/confs/demo.js:/confs/demo.js \
btgit.eastasia.cloudapp.azure.com:5000/demo/mongodb:latest \
bash -c "mongo mongodb://mongos:40000/demo --eval ${dqt}load('countActivity.js');${dqt}"

echo "create count_record container"
docker run -d --net=multi --name=count_record \
--restart=always \
-v /home/$user/confs/demo.js:/confs/demo.js \
btgit.eastasia.cloudapp.azure.com:5000/demo/mongodb:latest \
bash -c "mongo mongodb://mongos:40000/demo --eval ${dqt}load('countRecord.js');${dqt}"

echo "create remove_activity container"
docker run -d --net=multi --name=remove_activity \
--restart=always \
-v /home/$user/confs/demo.js:/confs/demo.js \
btgit.eastasia.cloudapp.azure.com:5000/demo/mongodb:latest \
bash -c "mongo mongodb://mongos:40000/demo --eval ${dqt}load('removeActivity.js');${dqt}"

echo "create remove_record container"
docker run -d --net=multi --name=remove_record \
--restart=always \
-v /home/$user/confs/demo.js:/confs/demo.js \
btgit.eastasia.cloudapp.azure.com:5000/demo/mongodb:latest \
bash -c "mongo mongodb://mongos:40000/demo --eval ${dqt}load('removeRecord.js');${dqt}"

echo "create remove_minute container"
docker run -d --net=multi --name=remove_minute \
--restart=always \
-v /home/$user/confs/demo.js:/confs/demo.js \
btgit.eastasia.cloudapp.azure.com:5000/demo/mongodb:latest \
bash -c "mongo mongodb://mongos:40000/demo --eval ${dqt}load('removeMinute.js');${dqt}"

echo "mongodb were initiated."
