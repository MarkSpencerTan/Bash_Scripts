#!/bin/bash

ip=$1
port=$2
while(true) do
	echo "Enter a command:"
	read cmd 
	echo $cmd > sample.txt
	socat UDP4-DATAGRAM:$ip:$port,broadcast ./sample.txt
done

