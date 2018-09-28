echo build elk images
registry="192.168.1.103:5000"

cd elasticsearch/
sudo docker build -t="$registry/elk630/elasticsearch" .
cd ../kibana/
sudo docker build -t="$registry/elk630/kibana" .
cd ../logstash/
sudo docker build -t="$registry/elk630/logstash" .
