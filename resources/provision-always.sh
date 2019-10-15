#!/bin/sh

# If you would like to do some extra provisioning which always runs you may
# add any commands you wish to this file and they will
# be run every time Homestead boots up

ifconfig eth0:1 172.27.67.15 netmask 255.255.255.0
ifconfig eth0:2 172.27.67.139 netmask 255.255.255.0
ifconfig eth0:3 172.27.67.104 netmask 255.255.255.0
ifconfig eth0:4 172.27.67.110 netmask 255.255.255.0
ifconfig eth0:5 172.27.67.147 netmask 255.255.255.0
ifconfig eth0:6 172.27.67.17 netmask 255.255.255.0


