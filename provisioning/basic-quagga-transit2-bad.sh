#!/bin/bash

apt-get update
apt-get install -y quagga

echo "zebra=yes
bgpd=yes
ospfd=no
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no" > /etc/quagga/daemons

echo "hostname Transit2
password ripe
log file /var/log/quagga/zebra.log
!
!
line vty
!" > /etc/quagga/zebra.conf

echo "hostname Transit2
password ripe
log file /var/log/quagga/bgpd.log
!
router bgp 2
 bgp router-id 85.1.2.1
 neighbor 85.1.2.2 remote-as 55
 neighbor 85.1.2.2 activate
 redistribute connected
!
line vty
!" > /etc/quagga/bgpd.conf
chown quagga: /etc/quagga/*
/etc/init.d/quagga restart
