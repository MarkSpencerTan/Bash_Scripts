#!/bin/bash
port=$1

socat -t1 UDP4-RECVFROM:$1,reuseaddr,broadcast OPEN:clientdata.txt
echo "got stuff"
cmd=$(cat clientdata.txt)
cmdresult=eval $cmd
echo $cmdresult
