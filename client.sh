#!/bin/bash

#the trap will cleaup temp files on exit
function cleanup {
  rm -r -f temp
  exit
}

trap cleanup SIGINT
trap cleanup EXIT


#Checks if you have exactly one arg for the port
if [[ $# > 0 ]]; then
	port=$1
else
	#reads port if you don't have any args
	echo "Enter port: "
	read port
fi

echo "Connecting to server port: ${port}"

#make temp directory if !exist
if [[ ! -d "temp" ]]; then
	mkdir temp
fi

cmd=""
while true; do
	echo -e "\nEnter a command to send..."
	read cmd

	if [[ "${cmd}" == "exit" ]]; then
		cleanup
	fi

	#writes the message to client.txt
	echo $cmd > temp/client.txt

	#sends the message to the server
	nc 127.0.0.1 $port < temp/client.txt

	# sends ip to the server to get response
	ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
	echo $ip > temp/ip.txt
	nc 127.0.0.1 $port < temp/ip.txt

	#client now listens at port for a response from server
	nc -l $port > temp/response.txt

	sleep 1

	echo ""
	cat temp/response.txt
done

