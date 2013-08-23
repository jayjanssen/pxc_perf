#!/bin/bash

# Import tests
. ./sysbench_defs.sh

# # Enable myisam support
# set_myisam_replication="echo -e \"[mysqld]\n\nwsrep_replicate_myisam = ON\n\" > /etc/my-pxc-extra.cnf"
# vagrant ssh node1 -c "$set_myisam_replication"
# vagrant ssh node2 -c "$set_myisam_replication"
# vagrant ssh node3 -c "$set_myisam_replication"

# # Rolling restart
# vagrant ssh node1 -c "service mysql restart"
# vagrant ssh node2 -c "service mysql restart"
# vagrant ssh node3 -c "service mysql restart"


node1_ip=`vagrant ssh node1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node1's ip: $node1_ip";

# #Master/Slave cluster tests
vagrant ssh client1 -c "$CLEANUP --mysql-host=$node1_ip"

vagrant ssh client1 -c "$PREPARE_MYISAM --mysql-host=$node1_ip"
sleep 120

echo "Master/Slave MyISAM Test"
vagrant ssh client1 -c "$RUN_TEST --mysql-host=$node1_ip" -- > results/ms_myisam.txt