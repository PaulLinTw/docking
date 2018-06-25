#!/bin/bash

#echo "Switch To Python27 Environment"
#source /opt/rh/python27/enable
#which python
python -V

Action="${1}"
if [ "$Action" == "" ]; then
	Action="stop"
fi

if [ "$Action" == "stop" -o "$Action" == "restart" ]; then
	{ # try
		pyid=$(ps aux | grep "python [r]eport.py" | awk '{print echo $2}')
		if [ "$pyid" != "" ]; then
			echo "Dropping ap report.py"
			sudo kill $pyid
		fi
	} || { # catch
		    echo "Failed to drop ap report.py"
	}
	sleep 5
fi

if [ "$Action" == "start" -o "$Action" == "restart" ]; then
	echo "Activate Python Virtual Environment ap"
	cd /ap
	#source bin/activate

	echo "Starting ap report.py"
	nohup python report.py 5000 >> report.log &

fi

