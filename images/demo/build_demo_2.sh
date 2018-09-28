registry="kvstore1:5000"
echo build all images
cd hadoop_builder/
sudo docker build -t="$registry/demo/hadoop" .
cd ../spark_builder/
sudo docker build -t="$registry/demo/spark" .
