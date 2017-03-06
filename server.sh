#!/bin/bash

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
    #reads the file from the server and stores it into server.out
    nc -l $port > server.out
    nc -l $port > clientip.out

    #saves the command from the server in cmd
    cmd=$(cat server.out)
    #saves the ip of the client
    client_ip=$(cat clientip.out)

    #executes cmd in the server and saves result
    echo $(eval $cmd) > server_response.out

    cat server_response.out
    
    nc $client_ip $port < server_response.out

    #remove temp files
    rm server.out
    rm server_response.out
    rm clientip.out
done

# while true; do 
#   nc -lvp $port -c "echo -n 'Your IP is: '; grep connect my.ip | cut -d'[' -f 3 | cut -d']' -f 1" 2> my.ip; 
# done

