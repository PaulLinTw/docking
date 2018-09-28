cd /home/vagrant/logstash-6.3.1
sudo LS_JAVA_OPTS="-Xmx2g -Xms2g" bin/logstash -f config/logstash.conf &
