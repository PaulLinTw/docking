source /vagrant/incl.sh

echo "install wget"
sudo yum install -y wget
sudo yum install -y sshpass

hd_ver="3.1.0"

echo "downlaoding hadoop-$hd_ver .."

cd /home/vagrant

wget -q http://www.us.apache.org/dist/hadoop/common/hadoop-$hd_ver/hadoop-$hd_ver.tar.gz

tar -zxf ./hadoop-$hd_ver.tar.gz -C /usr/local

cd /usr/local/

mv ./hadoop-$hd_ver ./hadoop

#sudo chown -R vagrant:vagrant ./hadoop

echo "copy config file into hadoop"
cp /home/vagrant/share/core-site.xml /usr/local/hadoop/etc/hadoop/
cp /home/vagrant/share/hdfs-site.xml /usr/local/hadoop/etc/hadoop/
cp /home/vagrant/share/mapred-site.xml /usr/local/hadoop/etc/hadoop/
cp /home/vagrant/share/yarn-site.xml /usr/local/hadoop/etc/hadoop/
cp /home/vagrant/share/workers /usr/local/hadoop/etc/hadoop/
echo "export JAVA_HOME=$JAVA_HOME" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

echo "zipping hadoop folder .."
cd /usr/local
rm -fr ./hadoop/tmp
tar -zcf ./hadoop.tar.gz ./hadoop

echo "hadoop deployed"
