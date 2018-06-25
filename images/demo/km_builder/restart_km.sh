kmid=$(ps aux | grep [k]afka-manager | awk '{print echo $2}')
if [ "$kmid" != "" ]; then
	echo Killing kafka manager
	kill $kmid
	sleep 5 # pause 5 sec
fi
echo Starting kafka manager
cd /km/kafka-manager/
rm RUNNING_PID
bin/kafka-manager -Dconfig.file=conf/application.conf -Dhttp.port=8080
