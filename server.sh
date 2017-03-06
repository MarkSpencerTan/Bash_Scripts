#!/bin/bash

#the trap will cleanup temp files on exit
function cleanup {
  echo "cleaning temp files..."
  rm server.out
  rm server_response.out
  rm clientip.out
}

trap cleanup SIGINT
trap cleanup EXIT

#Checks if you have exactly one arg for the port
if [[ $# > 0 ]]; then
  port=$1
else
  #reads port if you don't have any args
  echo "You can run this script with\n $0 <port>\n"
  echo "Enter port: "
  read port
fi

# Continuously listens for client connectuons.
while true; do
  echo "Server listening on port: ${port}..."
    #reads the command and ip from the client and stores it into server.out
    nc -l $port > server.out
    nc -l $port > clientip.out

    #saves the command from the server in cmd
    cmd="$(cat server.out)"
    #saves the ip of the client
    client_ip=$(cat clientip.out)

    #executes cmd in the server and saves result
    echo -e "$(eval $cmd)" > server_response.out

    sleep 1
    
    #sends the command output back to client
    nc $client_ip $port < server_response.out

    #remove temp files
    cleanup    
done
