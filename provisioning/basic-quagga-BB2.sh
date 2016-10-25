#!/bin/bash

modprobe ip_gre
ip tunnel add gre1 remote 5.3.1.1 local 5.2.1.1 ttl 255
ifconfig gre1 10.16.1.2 netmask 255.255.255.0
ifconfig gre1 up
apt-get update
apt-get install -y quagga
echo "router ospf
 network 10.1.2.0/24 area 1
 network 5.2.1.0/24 area 1
 network 2.2.1.0/24 area 1
 network 2.2.2.0/24 area 1
" > /etc/quagga/ospfd.conf

echo "zebra=yes
bgpd=yes
ospfd=yes
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no" > /etc/quagga/daemons

echo "hostname BB2
password ripe
log file /var/log/quagga/zebra.log
!
!
line vty
!" > /etc/quagga/zebra.conf

echo "hostname BB2
password ripe
log file /var/log/quagga/bgpd.log
!
router bgp 55
 bgp router-id 5.2.1.1
 neighbor 5.1.1.1 remote-as 55
 neighbor 5.1.1.1 activate
 neighbor 5.1.1.1 update-source 5.2.1.1
 neighbor 5.3.1.1 remote-as 55
 neighbor 5.3.1.1 activate
 neighbor 5.3.1.1 update-source 5.2.1.1
 neighbor 2.2.2.1 remote-as 22
 neighbor 2.2.2.1 activate
 neighbor 2.2.1.1 remote-as 11
 neighbor 2.2.1.1 activate
 redistribute static
!
line vty
!" > /etc/quagga/bgpd.conf
chown quagga: /etc/quagga/*
/etc/init.d/quagga restart
