source ./0_common_conf.sh
old_overlay="multi"
function reconnect(){
	echo
	echo "Reconnect Host $1"
	echo
	eval $(docker-machine env $1)
	exclude=($(docker ps -f name=swarm-agent -aq))
	ctnr=($(docker ps -aq))
	for i in "${ctnr[@]}"; do
		todo=true
		for j in "${exclude[@]}"; do
			if [[ "$i" == "$j" ]];then
				echo "$i is a swarm-agent container"
				todo=false
			fi	
		done
		if [[ "$todo" == "true" ]]; then
	
			echo "disconnecting $i from [$old_overlay].."
			docker network disconnect -f $old_overlay $i
			echo "connecting $i to [$overlay].."
			docker network connect $overlay $i
		fi
	done
}

reconnect $Master_Host
reconnect $Worker1_Host
reconnect $Worker2_Host
reconnect $Worker3_Host

echo "Done!"

