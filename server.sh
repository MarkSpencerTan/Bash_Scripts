#!/bin/bash

#the trap will cleanup temp files on exit
function cleanup {
  rm -f temp/server.out
  rm -f temp/clientip.out
  rm -f temp/server_response.out
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

#make temp directory if !exist
if [ ! -d "temp" ]; then
  mkdir temp
fi

# Continuously listens for client connectuons.
while true; do
  echo "Server listening on port: ${port}..."
    #reads the command and ip from the client and stores it into server.out
    nc -l $port > temp/server.out
    nc -l $port > temp/clientip.out

    #saves the command from the server in cmd
    cmd="$(cat temp/server.out)"
    #saves the ip of the client
    client_ip=$(cat temp/clientip.out)

    #evaluates command in the server and saves result
    echo -e "$(eval $cmd)" > temp/server_response.out

    sleep 1
    
    #sends the command output back to client
    nc $client_ip $port < temp/server_response.out
done
