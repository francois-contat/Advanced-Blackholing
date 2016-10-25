#!/bin/bash

apt-get update
apt-get install -y quagga
echo "router ospf
 network 85.1.1.0/24 area 1
 network 85.1.2.0/24 area 1
 network 85.1.3.0/24 area 1
 network 10.1.1.0/24 area 1
 network 10.1.2.0/24 area 1
 network 5.1.1.0/24 area 1
" > /etc/quagga/ospfd.conf

echo "zebra=yes
bgpd=yes
ospfd=yes
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no" > /etc/quagga/daemons

echo "hostname BB1
password ripe
log file /var/log/quagga/zebra.log
!
!
line vty
!" > /etc/quagga/zebra.conf

echo "hostname BB1
password ripe
log file /var/log/quagga/bgpd.log
!
router bgp 55
 bgp router-id 5.1.1.1
 neighbor 85.1.1.1 remote-as 1
 neighbor 85.1.1.1 activate
 neighbor 85.1.2.1 remote-as 2
 neighbor 85.1.2.1 activate
 neighbor 85.1.3.1 remote-as 3
 neighbor 85.1.3.1 activate
 neighbor 5.2.1.1 remote-as 55
 neighbor 5.2.1.1 activate
 neighbor 5.2.1.1 update-source 5.1.1.1
 neighbor 5.3.1.1 remote-as 55
 neighbor 5.3.1.1 activate
 neighbor 5.3.1.1 update-source 5.1.1.1
 redistribute static
 redistribute connected
!
line vty
!" > /etc/quagga/bgpd.conf
chown quagga: /etc/quagga/*
/etc/init.d/quagga restart
