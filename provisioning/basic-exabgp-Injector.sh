#!/bin/bash

apt-get update
apt-get install -y python python-pip
pip install exabgp

echo "neighbor 10.6.6.1 {
    local-address 10.6.6.2;
    local-as 66;
    peer-as 55;
    static {
        route 1.0.4.0/24 {
            next-hop  10.6.6.2; 
            community [ 66:6666 ];
        }
# Let's blackhole transit2-bad for 2.2.1.1 host
        route 85.1.2.1 {
            next-hop  10.6.6.2; 
            community [ 66:6666 ];
        }
        route 2.141.0.0/16 {
            next-hop  10.6.6.2; 
            community [ 66:6666 ];
        }
        route 2.2.1.1/32 {
            next-hop  10.6.6.2; 
            community [ 66:1234 ];
        }
    }
}" >/etc/exabgp.ini

