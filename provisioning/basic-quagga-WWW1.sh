#!/bin/bash

apt-get update
apt-get install -y quagga tcpdump

echo "zebra=yes
bgpd=yes
ospfd=no
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no" > /etc/quagga/daemons

echo "hostname WWW1
password ripe
log file /var/log/quagga/zebra.log
!
!
line vty
!" > /etc/quagga/zebra.conf

echo "hostname WWW1
password ripe
log file /var/log/quagga/bgpd.log
!
router bgp 11
 bgp router-id 2.2.1.1
 neighbor 2.2.1.2 remote-as 55
 neighbor 2.2.1.2 activate
 redistribute connected
!
line vty
!" > /etc/quagga/bgpd.conf
chown quagga: /etc/quagga/*
/etc/init.d/quagga restart
