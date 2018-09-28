source ./0_common_conf.sh

eval $(docker-machine env $Worker1_Host)
echo "create hadoop datanode1 container"
docker run -d --net=$overlay --name=datanode1 \
-v /home/$user/confs/hadoop/hdfs-site.xml:/usr/local/hadoop/etc/hadoop/hdfs-site.xml \
-v /home/$user/confs/hadoop/core-site.xml:/usr/local/hadoop/etc/hadoop/core-site.xml \
-v /home/$user/confs/hadoop/yarn-site.xml:/usr/local/hadoop/etc/hadoop/yarn-site.xml \
-v /home/$user/confs/hadoop/mapred-site.xml:/usr/local/hadoop/etc/hadoop/mapred-site.xml \
-v /home/$user/confs/hadoop/workers:/usr/local/hadoop/etc/hadoop/workers \
$registry/demo/hadoop:latest \
bash -c "ping localhost"

eval $(docker-machine env $Worker2_Host)
echo "create hadoop datanode2 container"
docker run -d --net=$overlay --name=datanode2 \
-v /home/$user/confs/hadoop/hdfs-site.xml:/usr/local/hadoop/etc/hadoop/hdfs-site.xml \
-v /home/$user/confs/hadoop/core-site.xml:/usr/local/hadoop/etc/hadoop/core-site.xml \
-v /home/$user/confs/hadoop/yarn-site.xml:/usr/local/hadoop/etc/hadoop/yarn-site.xml \
-v /home/$user/confs/hadoop/mapred-site.xml:/usr/local/hadoop/etc/hadoop/mapred-site.xml \
-v /home/$user/confs/hadoop/workers:/usr/local/hadoop/etc/hadoop/workers \
$registry/demo/hadoop:latest \
bash -c "ping localhost"

eval $(docker-machine env $Worker3_Host)
echo "create hadoop datanode3 container"
docker run -d --net=$overlay --name=datanode3 \
-v /home/$user/confs/hadoop/hdfs-site.xml:/usr/local/hadoop/etc/hadoop/hdfs-site.xml \
-v /home/$user/confs/hadoop/core-site.xml:/usr/local/hadoop/etc/hadoop/core-site.xml \
-v /home/$user/confs/hadoop/yarn-site.xml:/usr/local/hadoop/etc/hadoop/yarn-site.xml \
-v /home/$user/confs/hadoop/mapred-site.xml:/usr/local/hadoop/etc/hadoop/mapred-site.xml \
-v /home/$user/confs/hadoop/workers:/usr/local/hadoop/etc/hadoop/workers \
$registry/demo/hadoop:latest \
bash -c "ping localhost"

eval $(docker-machine env $Master_Host)
echo "create hadoop namenode container"
docker run -d --net=$overlay --name=namenode -p 9870:9870 -p 9000:9000 \
-v /home/$user/confs/hadoop/hdfs-site.xml:/usr/local/hadoop/etc/hadoop/hdfs-site.xml \
-v /home/$user/confs/hadoop/core-site.xml:/usr/local/hadoop/etc/hadoop/core-site.xml \
-v /home/$user/confs/hadoop/yarn-site.xml:/usr/local/hadoop/etc/hadoop/yarn-site.xml \
-v /home/$user/confs/hadoop/mapred-site.xml:/usr/local/hadoop/etc/hadoop/mapred-site.xml \
-v /home/$user/confs/hadoop/workers:/usr/local/hadoop/etc/hadoop/workers \
$registry/demo/hadoop:latest \
bash -c "./start_hadoop.sh"

echo "all service containers were created. please check clusters by portainer"
