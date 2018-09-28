registry="192.168.1.103:5000"

sudo docker push $registry/elk630/elasticsearch
sudo docker push $registry/elk630/logstash
sudo docker push $registry/elk630/kibana
