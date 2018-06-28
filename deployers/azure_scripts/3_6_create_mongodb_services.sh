source ./0_common_conf.sh

eval $(docker-machine env az-worker1)
echo "create mongoc1 container"
docker run -d --net=$overlay --name=mongoc1 --expose 30000 \
-v mongodb_configsvr:/var/lib/mongodb/configsvr \
$registry/demo/mongodb:latest \
bash -c "mongod --configsvr --replSet rs1 --storageEngine wiredTiger --port 30000 --dbpath /var/lib/mongodb/configsvr --logpath /var/lib/mongodb/configsvr/config.log --logappend"

echo "create mongo_primary1 container"
docker run -d --net=$overlay --name=mongo_primary1 --expose 20000 \
-v mongodb_primary:/var/lib/mongodb/primary \
-v /home/$user/confs/mongodb.primary.conf:/confs/mongodb.primary.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_01 -f /confs/mongodb.primary.conf"

echo "create mongo_secondary3 container"
docker run -d --net=$overlay --name=mongo_secondary3 --expose 20001 \
-v mongodb_secondary:/var/lib/mongodb/secondary \
-v /home/$user/confs/mongodb.secondary.conf:/confs/mongodb.secondary.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_03 -f /confs/mongodb.secondary.conf"

echo "create mongo_arbiter1 container"
docker run -d --net=$overlay --name=mongo_arbiter1 --expose 20002 \
-v mongodb_arbiter:/var/lib/mongodb/arbiter \
-v /home/$user/confs/mongodb.arbiter.conf:/confs/mongodb.arbiter.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_01 -f /confs/mongodb.arbiter.conf"

eval $(docker-machine env az-worker2)
echo "create mongoc2 container"
docker run -d --net=$overlay --name=mongoc2 --expose 30000 \
-v mongodb_configsvr:/var/lib/mongodb/configsvr \
$registry/demo/mongodb:latest \
bash -c "mongod --configsvr --replSet rs1 --storageEngine wiredTiger --port 30000 --dbpath /var/lib/mongodb/configsvr --logpath /var/lib/mongodb/configsvr/config.log --logappend"

echo "create mongo_primary2 container"
docker run -d --net=$overlay --name=mongo_primary2 --expose 20000 \
-v mongodb_primary:/var/lib/mongodb/primary \
-v /home/$user/confs/mongodb.primary.conf:/confs/mongodb.primary.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_02 -f /confs/mongodb.primary.conf"

echo "create mongo_secondary1 container"
docker run -d --net=$overlay --name=mongo_secondary1 --expose 20001 \
-v mongodb_secondary:/var/lib/mongodb/secondary \
-v /home/$user/confs/mongodb.secondary.conf:/confs/mongodb.secondary.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_01 -f /confs/mongodb.secondary.conf"

echo "create mongo_arbiter2 container"
docker run -d --net=$overlay --name=mongo_arbiter2 --expose 20002 \
-v mongodb_arbiter:/var/lib/mongodb/arbiter \
-v /home/$user/confs/mongodb.arbiter.conf:/confs/mongodb.arbiter.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_02 -f /confs/mongodb.arbiter.conf"

eval $(docker-machine env az-worker3)
echo "create mongoc3 container"
docker run -d --net=$overlay --name=mongoc3 --expose 30000 \
-v mongodb_configsvr:/var/lib/mongodb/configsvr \
$registry/demo/mongodb:latest \
bash -c "mongod --configsvr --replSet rs1 --storageEngine wiredTiger --port 30000 --dbpath /var/lib/mongodb/configsvr --logpath /var/lib/mongodb/configsvr/config.log --logappend"

echo "create mongo_primary3 container"
docker run -d --net=$overlay --name=mongo_primary3 --expose 20000 \
-v mongodb_primary:/var/lib/mongodb/primary \
-v /home/$user/confs/mongodb.primary.conf:/confs/mongodb.primary.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_03 -f /confs/mongodb.primary.conf"

echo "create mongo_secondary2 container"
docker run -d --net=$overlay --name=mongo_secondary2 --expose 20001 \
-v mongodb_secondary:/var/lib/mongodb/secondary \
-v /home/$user/confs/mongodb.secondary.conf:/confs/mongodb.secondary.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_02 -f /confs/mongodb.secondary.conf"

echo "create mongo_arbiter3 container"
docker run -d --net=$overlay --name=mongo_arbiter3 --expose 20002 \
-v mongodb_arbiter:/var/lib/mongodb/arbiter \
-v /home/$user/confs/mongodb.arbiter.conf:/confs/mongodb.arbiter.conf \
$registry/demo/mongodb:latest \
bash -c "mongod --replSet sh_03 -f /confs/mongodb.arbiter.conf"

sleep 5

eval $(docker-machine env az-worker1)
echo "initiate replicaset in configsvr cluster"
docker exec mongoc1 mongo mongoc1:30000 \
--eval "rs.initiate( { _id:'rs1', members:[{ _id:0,host:'mongoc1:30000'},{ _id:1,host:'mongoc2:30000'},{ _id:2,host:'mongoc3:30000'}] });"

echo "initiate replicaset in shard 01"
docker exec mongo_primary1 mongo mongo_primary1:20000 --eval "rs.initiate( { _id:'sh_01', members:[{ _id:0,host:'mongo_primary1:20000',priority:2},{ _id:1,host:'mongo_secondary1:20001'},{_id:2,host:'mongo_arbiter1:20002',arbiterOnly:true}] });"

eval $(docker-machine env az-worker2)
echo "initiate replicaset in shard 02"
docker exec mongo_primary2 mongo mongo_primary2:20000 --eval "rs.initiate( { _id:'sh_02', members:[{ _id:0,host:'mongo_primary2:20000',priority:2},{ _id:1,host:'mongo_secondary2:20001'},{_id:2,host:'mongo_arbiter2:20002',arbiterOnly:true}]  });"

eval $(docker-machine env az-worker3)
echo "initiate replicaset in shard 03"
docker exec mongo_primary3 mongo mongo_primary3:20000 --eval "rs.initiate( { _id:'sh_03', members:[{ _id:0,host:'mongo_primary3:20000',priority:2},{ _id:1,host:'mongo_secondary3:20001'},{_id:2,host:'mongo_arbiter3:20002',arbiterOnly:true}]  });"

sleep 5

eval $(docker-machine env az-master)

echo "create single mongos container"
docker run -d --net=$overlay --name=mongos -p 40000:40000 \
-v mongodb_router:/var/lib/mongodb/mongos \
-v /home/$user/confs/demo.js:/confs/demo.js \
$registry/demo/mongodb:latest \
bash -c "mongos --port 40000 --configdb 'rs1/mongoc1:30000,mongoc2:30000,mongoc3:30000' --logpath /var/lib/mongodb/mongos/route.log --logappend"

sleep 10

echo "add shard 01 to server"
docker exec mongos mongo mongos:40000/admin --eval "db.runCommand({addshard:'sh_01/mongo_primary1:20000'});"
echo "add shard 02 to server"
docker exec mongos mongo mongos:40000/admin --eval "db.runCommand({addshard:'sh_02/mongo_primary2:20000'});"
echo "add shard 03 to server"
docker exec mongos mongo mongos:40000/admin --eval "db.runCommand({addshard:'sh_03/mongo_primary3:20000'});"

sleep 10

eval $(docker-machine env az-az-worker1)
echo "create exporter1 container"
docker run -d --net=$overlay --name=exporter1 --expose 9001 \
$registry/demo/mongoexporter:latest \
mongodb_exporter -mongodb.uri=mongodb://mongo_primary1:20000/admin -groups.enabled= "op_counters,op_counters_repl,asserts,durability,background_flushing, connections,global_lock,index_counters,network,memory,locks,metrics"

eval $(docker-machine env az-az-worker2)
echo "create exporter2 container"
docker run -d --net=$overlay --name=exporter2 --expose 9001 \
$registry/demo/mongoexporter:latest \
mongodb_exporter -mongodb.uri=mongodb://mongo_primary2:20000/admin -groups.enabled= "op_counters,op_counters_repl,asserts,durability,background_flushing, connections,global_lock,index_counters,network,memory,locks,metrics"

eval $(docker-machine env az-az-worker3)
echo "create exporter3 container"
docker run -d --net=$overlay --name=exporter3 --expose 9001 \
$registry/demo/mongoexporter:latest \
mongodb_exporter -mongodb.uri=mongodb://mongo_primary3:20000/admin -groups.enabled= "op_counters,op_counters_repl,asserts,durability,background_flushing, connections,global_lock,index_counters,network,memory,locks,metrics"

echo "all mongodb were created."
