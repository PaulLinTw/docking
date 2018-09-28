source /vagrant/incl.sh

sc_ver="2.12.6"

echo "downlaod scala $sc_ver"

cd /home/vagrant

wget -q https://downloads.lightbend.com/scala/$sc_ver/scala-$sc_ver.tgz
tar -zxf ./scala-$sc_ver.tgz -C /usr/local

cd /usr/local/

mv ./scala-$sc_ver ./scala
chown vagrant.vagrant -R scala

echo "update /etc/profile"

sudo echo "export SCALA_HOME=/usr/local/scala" >> /etc/profile
sudo echo "export PATH=\$PATH:\$SCALA_HOME/bin" >> /etc/profile

source /etc/profile
scala -version
