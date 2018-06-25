registry="192.168.1.103:5000"

sudo docker push $registry/xpack/elasticsearch
sudo docker push $registry/xpack/logstash
sudo docker push $registry/xpack/kibana
