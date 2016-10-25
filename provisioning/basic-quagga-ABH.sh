#!/bin/bash

modprobe ip_gre
ip tunnel add gre1 remote 5.2.1.1 local 5.3.1.1 ttl 255
ifconfig gre1 10.16.1.1 netmask 255.255.255.0
ifconfig gre1 up
apt-get update
apt-get install -y quagga tcpdump
echo "router ospf
 network 10.1.1.0/24 area 1
 network 10.16.1.0/24 area 1
 network 5.3.1.0/24 area 1" > /etc/quagga/ospfd.conf

echo "zebra=yes
bgpd=yes
ospfd=yes
ospf6d=no
ripd=no
ripngd=no
isisd=no
babeld=no" > /etc/quagga/daemons

echo "hostname ABH
password ripe
log file /var/log/quagga/zebra.log
!
!
line vty
!" > /etc/quagga/zebra.conf

echo "hostname ABH
password ripe
log file /var/log/quagga/bgpd.log
!
router bgp 55
 bgp router-id 5.3.1.1
 neighbor 5.2.1.1 remote-as 55
 neighbor 5.2.1.1 activate
 neighbor 5.2.1.1 update-source 5.3.1.1
 neighbor 5.1.1.1 remote-as 55
 neighbor 5.1.1.1 activate
 neighbor 5.1.1.1 update-source 5.3.1.1
 neighbor 10.6.6.2 remote-as 66
 neighbor 10.6.6.2 route-map from-injector in
 neighbor 10.6.6.2 next-hop-self
 neighbor 10.6.6.2 activate
!
ip community-list standard drop-via-urpf permit 66:6666
ip community-list standard protect permit 66:1234
!
route-map from-injector permit 10
 match community protect 
 set ip next-hop 10.16.1.2
 set local-preference 1500
!
route-map from-injector permit 20
 match community drop-via-urpf exact-match
 set community no-advertise
 set local-preference 6666
!
line vty
!" > /etc/quagga/bgpd.conf
chown quagga: /etc/quagga/*
/etc/init.d/quagga restart
