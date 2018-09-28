source /vagrant/incl.sh

sp_ver="2.3.1"

echo "downlaoding spark-$sp_ver .."

cd /home/vagrant

wget -q http://apache.stu.edu.tw/spark/spark-$sp_ver/spark-$sp_ver-bin-hadoop2.7.tgz

tar -zxf ./spark-$sp_ver-bin-hadoop2.7.tgz -C /usr/local

cd /usr/local/

mv ./spark-$sp_ver-bin-hadoop2.7 ./spark

echo "copy spark-env.sh into spark/conf"
cp /home/vagrant/share/spark-env.sh /usr/local/spark/conf/
echo "export JAVA_HOME=$JAVA_HOME" >> /usr/local/spark/conf/spark-env.sh

chown vagrant.vagrant -R spark

echo "zipping spark folder .."
cd /usr/local
tar -zcf ./spark.tar.gz ./spark

echo "spark deployed"

