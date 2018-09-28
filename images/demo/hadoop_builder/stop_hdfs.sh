source /vagrant/incl.sh

echo stopping hdfs ..
cd /usr/local/hadoop/
sbin/stop-yarn.sh
sbin/stop-dfs.sh
jps
echo hdfs stopped.
