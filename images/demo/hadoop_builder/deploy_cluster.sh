source /vagrant/incl.sh

mkdir -p /home/vagrant/.ssh

echo "create empty-password rsa key for vagrant"

ssh-keygen -P "" -t rsa -f /home/vagrant/.ssh/id_rsa

ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub @PREFIXER_master1
ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub @PREFIXER_slave1
ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub @PREFIXER_slave2
ssh-copy-id -i /home/vagrant/.ssh/id_rsa.pub @PREFIXER_slave3

echo "copy hadoop.tar.gz into workers"
cd /usr/local
scp ./hadoop.tar.gz @PREFIXER_slave1:/home/vagrant
scp ./hadoop.tar.gz @PREFIXER_slave2:/home/vagrant
scp ./hadoop.tar.gz @PREFIXER_slave3:/home/vagrant

echo "unzip hadoop.tar.gz in @PREFIXER_slave1"
ssh @PREFIXER_slave1 "sudo tar -zxf /home/vagrant/hadoop.tar.gz -C /usr/local"
echo "unzip hadoop.tar.gz in @PREFIXER_slave2"
ssh @PREFIXER_slave2 "sudo tar -zxf /home/vagrant/hadoop.tar.gz -C /usr/local"
echo "unzip hadoop.tar.gz in @PREFIXER_slave3"
ssh @PREFIXER_slave3 "sudo tar -zxf /home/vagrant/hadoop.tar.gz -C /usr/local"

echo "copy spark.tar.gz into workers"
cd /usr/local
scp ./spark.tar.gz @PREFIXER_slave1:/home/vagrant
scp ./spark.tar.gz @PREFIXER_slave2:/home/vagrant
scp ./spark.tar.gz @PREFIXER_slave3:/home/vagrant

echo "unzip spark.tar.gz in @PREFIXER_slave1"
ssh @PREFIXER_slave1 "sudo tar -zxf /home/vagrant/spark.tar.gz -C /usr/local"
echo "unzip spark.tar.gz in @PREFIXER_slave2"
ssh @PREFIXER_slave2 "sudo tar -zxf /home/vagrant/spark.tar.gz -C /usr/local"
echo "unzip spark.tar.gz in @PREFIXER_slave3"
ssh @PREFIXER_slave3 "sudo tar -zxf /home/vagrant/spark.tar.gz -C /usr/local"
