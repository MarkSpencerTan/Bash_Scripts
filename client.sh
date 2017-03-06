#Checks if you have exactly one arg for the port
if [[ $# > 0 ]]; then
	port=$1
else
	#reads port if you don't have any args
	echo -e "You can run this script with\n $0 <port>"
	echo "Enter port: "
	read port
fi

echo "Connecting to server port: ${port}"

cmd=""
while true; do
	echo -e "Enter a command to send..."
	read cmd
	#writes the message to client.txt
	echo $cmd > client.txt

	#sends the message to the server
	nc 127.0.0.1 $port < client.txt

	# sends ip to the server to get response
	ip=`ifconfig|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/'`
	echo $ip > ip.txt
	nc 127.0.0.1 $port < ip.txt

	#client now listens at port for a response from server
	nc -l $port > response.txt

	sleep .5

	#deletes the temporary client files
	rm client.txt
	rm ip.txt
	rm response.txt
done
