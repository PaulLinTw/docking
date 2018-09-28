
read -p "Type \"yes\" to append JAVA_HOM into spark-env.sh or \"Enter\" to skip." ans1
if [[ $ans1 == "yes" ]]; then
	echo "export JAVA_HOME=$JAVA_HOME" >> share/spark-env.sh
fi

read -p "Type \"yes\" to copy spark-env.sh config files into all nodes or \"Enter\" to skip." ans2
if [[ $ans2 == "yes" ]]; then
	scp share/spark-env.sh vagrant@@PREFIXER_master1:/usr/local/spark/conf/
	scp share/spark-env.sh  vagrant@@PREFIXER_slave1:/usr/local/spark/conf/
	scp share/spark-env.sh  vagrant@@PREFIXER_slave2:/usr/local/spark/conf/
	scp share/spark-env.sh  vagrant@@PREFIXER_slave3:/usr/local/spark/conf/
fi

echo starting spark master..
ssh vagrant@@PREFIXER_master1 "/usr/local/spark/sbin/start-master.sh"
echo starting worker on @PREFIXER_master1..
ssh vagrant@@PREFIXER_master1 "/usr/local/spark/sbin/start-slave.sh spark://@PREFIXER_master1:7077 && ${JAVA_HOME}/bin/jps"
echo starting worker @PREFIXER_slave1..
ssh vagrant@@PREFIXER_slave1 "/usr/local/spark/sbin/start-slave.sh spark://@PREFIXER_master1:7077 && ${JAVA_HOME}/bin/jps"
echo starting worker @PREFIXER_slave2..
ssh vagrant@@PREFIXER_slave2 "/usr/local/spark/sbin/start-slave.sh spark://@PREFIXER_master1:7077 && ${JAVA_HOME}/bin/jps"
echo starting worker @PREFIXER_slave3..
ssh vagrant@@PREFIXER_slave3 "/usr/local/spark/sbin/start-slave.sh spark://@PREFIXER_master1:7077 && ${JAVA_HOME}/bin/jps"
echo spark cluster started
