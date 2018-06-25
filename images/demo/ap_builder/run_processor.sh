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
		pyid=$(ps aux | grep "python [p]rocess_record.py" | awk '{print echo $2}')
		if [ "$pyid" != "" ]; then
			echo "Dropping ap process_record.py"
			sudo kill $pyid
		fi
	} || { # catch
		    echo "Failed to drop ap process_record.py"
	}
	{ # try
		pyid=$(ps aux | grep "python [p]rocess_activity.py" | awk '{print echo $2}')
		if [ "$pyid" != "" ]; then
			echo "Dropping ap process_activity.py"
			sudo kill $pyid
		fi
	} || { # catch
		    echo "Failed to drop ap process_activity.py"
	}
	sleep 5
fi

if [ "$Action" == "start" -o "$Action" == "restart" ]; then
	echo "Activate Python Virtual Environment ap"
	cd /ap
	#source bin/activate

	echo "Starting ap process_record.py"
	python process_record.py &

	echo "Starting ap process_activities.py"
	python process_activity.py &
fi

