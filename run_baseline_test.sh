#!/bin/bash

# Import tests
. ./sysbench_defs.sh


node1_ip=`vagrant ssh node1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node1's ip: $node1_ip";


# Standalone PXC node
vagrant ssh node2 -c "service mysql stop"
vagrant ssh node3 -c "service mysql stop"

vagrant ssh client1 -c "$CLEANUP --mysql-host=$node1_ip"
vagrant ssh client1 -c "$PREPARE_INNODB --mysql-host=$node1_ip"
sleep 120

echo "Single Node Innodb Test"
vagrant ssh client1 -c "$RUN_TEST --mysql-host=$node1_ip" -- > results/1n_innodb.txt


# Standalone PXC node without WSREP enabled
vagrant ssh node1 -c "sed -i.bak -e 's/^\(wsrep.*\)/\#\1/g' /etc/my.cnf"
vagrant ssh node1 -c "service mysql restart"

vagrant ssh client1 -c "$CLEANUP --mysql-host=$node1_ip"
vagrant ssh client1 -c "$PREPARE_INNODB --mysql-host=$node1_ip"
sleep 120

echo "Standalone Innodb Test"
vagrant ssh client1 -c "$RUN_TEST --mysql-host=$node1_ip" -- > results/standalone_innodb.txt

vagrant ssh node1 -c "mv /etc/my.cnf.bak /etc/my.cnf"
vagrant ssh node1 -c "service mysql stop"
vagrant ssh node1 -c "service mysql bootstrap-pxc"
