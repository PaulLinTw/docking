registry="kvstore1:5000"
echo build all images
cd base_builder/
sudo docker build -t="$registry/demo/base" .
cd ../java_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/java8" .
cd ../zookeeper_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/zookeeper" . 
cd ../kafka_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/kafka" .
cd ../prometheus_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/prometheus" .
cd ../ap_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/ap" .
cd ../km_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/km" .
cd ../mongodb_builder/
sudo docker build --build-arg registry=$registry -t="$registry/demo/mongodb" .
cd ../redis_builder/
sudo docker build -t="$registry/demo/redis" .
cd ../analyze_builder/
sudo docker build -t="$registry/demo/analyze" .
cd ../portal_builder/
sudo docker build -t="$registry/demo/portal" .
cd ../exporter_builder/
sudo docker build -t="$registry/demo/mongoexporter" .
cd ../graphite_exporter/
sudo docker build -t="$registry/demo/graphite_exporter" .
cd ../grafana_builder/
sudo docker build -t="$registry/demo/grafana" .
cd ../kafka_sasl_builder/
sudo docker build --build-arg registry=$registry -t="$registry/sasl/kafka" .
cd ../zookeeper_sasl_builder/
sudo docker build --build-arg registry=$registry -t="$registry/sasl/zookeeper" .
