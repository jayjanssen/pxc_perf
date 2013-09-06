#!/bin/bash

# Test commands
BASE_OPTIONS="--mysql-user=test --mysql-db=test --oltp-table-size=1000000 --oltp-tables-count=5"

PARALLEL_PREPARE="sysbench --test=sysbench_tests/db/parallel_prepare.lua $BASE_OPTIONS --num-threads=8"
PREPARE_MYISAM="$PARALLEL_PREPARE --mysql-table-engine=MyISAM run"
PREPARE_INNODB="$PARALLEL_PREPARE --mysql-table-engine=InnoDB run"

RUN_TEST="sysbench --test=sysbench_tests/db/update_index.lua $BASE_OPTIONS --oltp-dist-type=gauss --max-requests=0 --max-time=600 --num-threads=64 --report-interval=1 run"

CLEANUP="sysbench --test=sysbench_tests/db/common.lua $BASE_OPTIONS cleanup"
node1_ip=`vagrant ssh node1 -c "ip a l | grep eth0 | grep inet | awk '{print \\$2}' | awk -F/ '{print \\$1}'"`
echo "Node1's ip: $node1_ip";

#Master/Slave cluster tests
# vagrant ssh client1 -c "$CLEANUP --mysql-host=$node1_ip"

# vagrant ssh client1 -c "$PREPARE_INNODB --mysql-host=$node1_ip"
# sleep 120

echo "Master/Slave Innodb Test"
vagrant ssh client1 -c "$RUN_TEST --mysql-host=$node1_ip" -- > results/simple.txt
