#!/bin/bash

#the trap will cleaup temp files on exit
function cleanup {
  rm -f temp/client.txt
  rm -f temp/ip.txt
  rm -f temp/response.txt
  exit
}

trap cleanup SIGINT
trap cleanup EXIT

ip=localhost

#Checks if you have one arg for the port
if [[ $# == 1 ]]; then
	port=$1
	echo "Enter IP: "
	read ip
#Checks if you have two arg for the ip and port
elif [[ $# == 2 ]]; then
	ip=$1
	port=$2
else
	#reads ip and port if you don't have any args
	echo "Enter IP: "
	read ip
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

	#exits script if user enters 'exit'
	if [[ "${cmd}" == "exit" ]]; then
		cleanup
	fi

	#writes the message to client.txt
	echo $cmd > temp/client.txt

	#sends the message to the server
	nc $ip $port < temp/client.txt

	# sends ip to the server to get response
	server_ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
	echo $server_ip > temp/ip.txt
	nc $ip $port < temp/ip.txt

	#client now listens at port for a response from server
	nc -l $port > temp/response.txt

	sleep 1

	echo ""
	cat temp/response.txt
done

