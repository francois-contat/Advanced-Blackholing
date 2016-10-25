# Advanced BlackHoling - simple PoC based on Vagrant


## Overview

Vagrant files in order to reproduce de PoC of ABH.

ABH, for Advanced Blackholing, intends to use uRPF and diverting traffic through routing protocols in order to mitigate DDoS.

This projects reproduce a simple architecture with 3 transit providers, a backbone and 2 customers.

Pings are generated through transit providers to WWW1.

The ABH router advertises the route of the attacked service, redirect it through a GRE tunnel directly to BB2 to finally reach the WWW1 server.

The traffic is then forced to flow through ABH-router which will mitigate traffic with uRPF by simply receiving routes of IPs we want to blackhole.

This technique was presented on october 25th 2016 at Ripe73
https://ripe73.ripe.net/presentations/62-spinoff.pdf

## Try it yourself

This Poc is packaged to be easily tested using Vagrant. On your host, you will
only need to install Vagrant, and VirtualBox.

# Architecture

3 transit providers : transit1-good (AS1), transit2-bad (AS2), transit3-mixed (AS3)

The transit providers are all connected through eBGP with BB1

Internal backbone : BB1, BB2, ABH (as 55)
The internal backbone runs ospf and iBGP

Injector : exabgp connecting through eBGP

2 customers : WWW1 (AS11) and WWW2 (AS22)

The customers are connected through eBGP with BB2


### Preliminary setup on the host

Use the following commands to build the architecture, and send some traffic
from the clients:

```shell
$ vagrant up
$ vagrant provision
```

Let's send the icmp pings to the WWW1 (2.2.1.1)

```shell
$ ./launch-pings.sh

```

The ping payload will be used in the demo to filter packets, and corresponds to:
```python
$ python
>>> "Hello RIPE73 !".encode("hex")
'48656c6c6f205249504537332021'
```

### Watch incoming traffic on the server

For the sake of simplicity, this done using tcpdump:
```shell
       $ vagrant ssh WWW1
(WWW1) $ sudo tcpdump -i eth1 -X icmp[icmptype] == 8
```


### Divert traffic to ABH router and filter the bad transit provider (transit2-bad)

This is simply performed by adding a new route through exabgp:
```shell
$ vagrant ssh Injector -- 'exabgp /etc/exabgp.ini &'
```

### Filter the mixed client

Bad clients from the client-mixed VM can be filtered based on the RIPE73 string
found in their ICMP payload:
```shell
$ vagrant ssh ABH-router -- 'sudo iptables -A FORWARD -s 10.0.0.3 -m string --algo bm --string RIPE73 -j DROP'
```

### See the packets filtered by urpf

You can see all the packets dropped by urpf on the ABH-router4

```shell
$ vagrant ssh ABH-router
(ABH-Router) $ dmesg
```
