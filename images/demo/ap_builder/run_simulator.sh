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
		pyid=$(ps aux | grep "python [s]imulate_record.py" | awk '{print echo $2}')
		if [ "$pyid" != "" ]; then
			echo "Dropping ap simulate_record.py"
			sudo kill $pyid
		fi
	} || { # catch
		    echo "Failed to drop ap simulate_record.py"
	}
	{ # try
		pyid=$(ps aux | grep "python [s]imulate_activity.py" | awk '{print echo $2}')
		if [ "$pyid" != "" ]; then
			echo "Dropping ap simulate_activity.py"
			sudo kill $pyid
		fi
	} || { # catch
		    echo "Failed to drop ap simulate_activity.py"
	}
	sleep 5
fi

if [ "$Action" == "start" -o "$Action" == "restart" ]; then
	echo "Activate Python Virtual Environment ap"
	cd /ap
	#source bin/activate

	echo "Starting ap simulate_record.py"
	python simulate_record.py &

	echo "Starting ap simulate_activity.py"
	python simulate_activity.py &
fi

