cd /usr/local/spark
./bin/spark-submit \
  --master spark://@PREFIXER_master1:7077 \
  --files=/usr/local/spark/conf/metrics.properties \
  --conf spark.metrics.conf=metrics.properties \
  /home/vagrant/share/test.py
