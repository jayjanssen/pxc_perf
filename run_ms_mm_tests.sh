#!/bin/bash

# Import tests
. ./sysbench_defs.sh
# 
node1_ip=`vagrant ssh node1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node1's ip: $node1_ip";
node2_ip=`vagrant ssh node2 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node2's ip: $node2_ip";
node3_ip=`vagrant ssh node3 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node3's ip: $node3_ip";


#Master/Slave cluster tests
vagrant ssh client1 -c "$CLEANUP --mysql-host=$node1_ip"

vagrant ssh client1 -c "$PREPARE_INNODB --mysql-host=$node1_ip"
sleep 120

echo "Master/Slave Innodb Test"
vagrant ssh client1 -c "$RUN_TEST --mysql-host=$node1_ip" -- > results/ms_innodb.txt

sleep 120

echo "Multi Writer Innodb Test (21 threads each)"
vagrant ssh client1 -c "$RUN_TEST --num-threads=21 --mysql-host=$node1_ip" -- > results/mm_innodb_1.txt &
vagrant ssh client1 -c "$RUN_TEST --num-threads=21 --mysql-host=$node2_ip" -- > results/mm_innodb_2.txt &
vagrant ssh client1 -c "$RUN_TEST --num-threads=21 --mysql-host=$node3_ip" -- > results/mm_innodb_3.txt
