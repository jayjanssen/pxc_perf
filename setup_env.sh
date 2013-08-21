#!/bin/bash


vagrant up client1 --provider=aws &
vagrant up node1 --provider=aws &
vagrant up node2 --provider=aws &
vagrant up node3 --provider=aws
