echo build elk images
registry="192.168.1.103:5000"

cd elasticsearch/
sudo docker build -t="$registry/xpack/elasticsearch" .
cd ../kibana/
sudo docker build -t="$registry/xpack/kibana" .
cd ../logstash/
sudo docker build -t="$registry/xpack/logstash" .
