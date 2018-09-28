source /vagrant/incl.sh

cd go/src/github.com/prometheus/graphite_exporter
./graphite_exporter --graphite.mapping-config="/home/vagrant/share/ge_mapping" &
