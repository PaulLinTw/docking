registry="kvstore1:5000"

sudo docker push $registry/xpack/elasticsearch
sudo docker push $registry/xpack/logstash
sudo docker push $registry/xpack/kibana
