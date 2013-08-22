#!/bin/bash



client1_ip=`vagrant ssh client1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Client1's ip: $client1_ip";


node1_ip=`vagrant ssh node1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node1's ip: $node1_ip";

# Grant access to client server
vagrant ssh node1 -c "mysql -e \"grant all on test.* to test@'$client1_ip'\""


mysql_connect="mysql -h $node1_ip -u test test"

# Load schema and data
vagrant ssh client1 -c "$mysql_connect < tpcc-mysql/create_table.sql"

vagrant ssh client1 -c "cd tpcc-mysql; ./tpcc_load $node1_ip test test '' 1"

