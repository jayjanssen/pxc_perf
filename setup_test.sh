#!/bin/bash


client1_ip=`vagrant ssh client1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Client1's ip: $client1_ip";

node1_ip=`vagrant ssh node1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node1's ip: $node1_ip";
node2_ip=`vagrant ssh node2 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node2's ip: $node2_ip";
node3_ip=`vagrant ssh node3 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node3's ip: $node3_ip";



# Grant access to client server
vagrant ssh node1 -c "mysql -e \"grant all on test.* to test@'$client1_ip'\""


mysql_connect="mysql -h $node1_ip -u test test"

# Load schema and data
vagrant ssh client1 -c "$mysql_connect < tpcc-mysql/create_table.sql"

node_array=( $node1_ip $node2_ip $node3_ip )
node_counter=0

max_wh=20
big_command="cd tpcc-mysql; "
for wh in $(seq 1 $max_wh)
do
	echo -n "WH: $wh "
	for part in $(seq 1 4)
	do

		this_node=${node_array[$node_counter]}
		node_counter=$((node_counter+1))
		if [ $node_counter -gt 2 ]; then
			node_counter=0
		fi

		echo -n "$part ($this_node) "
		big_command="$big_command ./tpcc_load $this_node test test '' $max_wh $part $wh $wh &"
	done
	echo

done

vagrant ssh client1 -c "$big_command"