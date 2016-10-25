# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "transit1-good" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "transit1-good"
    machine.vm.network "private_network", ip:"85.1.1.1/30", virtualbox__intnet: "Transit1_BB1"
    machine.vm.network "private_network", ip:"66.1.1.1/32", virtualbox__intnet: "ping_source_good"
    machine.vm.provision "shell", inline: "echo 1 > /proc/sys/net/ipv4/ip_forward"
    machine.vm.provision "shell", path:"provisioning/basic-quagga.sh"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-transit1-good.sh"
  end


  config.vm.define "transit2-bad" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "transit2-bad"
    machine.vm.network "private_network", ip:"85.1.2.1/30", virtualbox__intnet: "Transit2_BB1"
    machine.vm.network "private_network", ip:"66.2.1.1/32", virtualbox__intnet: "ping_source_bad"
    machine.vm.provision "shell", inline: "echo 1 > /proc/sys/net/ipv4/ip_forward"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-transit2-bad.sh"
  end

  config.vm.define "transit3-mixed" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "transit3-mixed"
    machine.vm.network "private_network", ip:"85.1.3.1/30", virtualbox__intnet: "Transit3_BB1"
    machine.vm.network "private_network", ip:"66.3.1.1/32", virtualbox__intnet: "ping_source_mixed"
    machine.vm.provision "shell", inline: "echo 1 > /proc/sys/net/ipv4/ip_forward"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-transit3-mixed.sh"
  end

  config.vm.define "BB1" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "BB1"
    machine.vm.network "private_network", ip:"85.1.1.2/30", virtualbox__intnet: "Transit1_BB1"
    machine.vm.network "private_network", ip:"85.1.2.2/30", virtualbox__intnet: "Transit2_BB1"
    machine.vm.network "private_network", ip:"85.1.3.2/30", virtualbox__intnet: "Transit3_BB1"
    machine.vm.network "private_network", ip:"10.1.1.1/30", virtualbox__intnet: "BB1_ABH"
    machine.vm.network "private_network", ip:"10.1.2.1/30", virtualbox__intnet: "BB1_BB2"
    machine.vm.network "private_network", ip:"5.1.1.1/30", virtualbox__intnet: "loopback_BB1"
    machine.vm.provision "shell", inline: "echo 1 > /proc/sys/net/ipv4/ip_forward"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-BB1.sh"
  end

  config.vm.define "ABH-router" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "ABH-router"
    machine.vm.network "private_network", ip:"10.1.1.2/30", virtualbox__intnet: "BB1_ABH"
    machine.vm.network "private_network", ip:"10.6.6.1/30", virtualbox__intnet: "ABH_Injector"
    machine.vm.network "private_network", ip:"5.3.1.1/30", virtualbox__intnet: "loopback_ABH"
    machine.vm.provision "shell", inline: "echo 1 > /proc/sys/net/ipv4/ip_forward; echo 1 > /proc/sys/net/ipv4/conf/eth1/rp_filter; echo 1 > /proc/sys/net/ipv4/conf/eth1/log_martians"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-ABH.sh"
  end

  config.vm.define "Injector" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "Injector"
    machine.vm.network "private_network", ip:"10.6.6.2/30", virtualbox__intnet: "ABH_Injector"
    machine.vm.provision "shell", path:"provisioning/basic-exabgp-Injector.sh"
  end

  config.vm.define "BB2" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "BB2"
    machine.vm.network "private_network", ip:"10.1.2.2/30", virtualbox__intnet: "BB1_BB2"
    machine.vm.network "private_network", ip:"2.2.1.2/24", virtualbox__intnet: "BB2_W1"
    machine.vm.network "private_network", ip:"2.2.2.2/24", virtualbox__intnet: "BB2_W2"
    machine.vm.network "private_network", ip:"5.2.1.1/30", virtualbox__intnet: "loopback_BB2"
    machine.vm.provision "shell", inline: "echo 1 > /proc/sys/net/ipv4/ip_forward"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-BB2.sh"
  end

  config.vm.define "WWW1" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "WWW1"
    machine.vm.network "private_network", ip:"2.2.1.1/24", virtualbox__intnet: "BB2_W1"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-WWW1.sh"
  end

  config.vm.define "WWW2" do |machine|
    machine.vm.box = "debian/jessie64"
    machine.vm.hostname = "WWW2"
    machine.vm.network "private_network", ip:"2.2.2.1/24", virtualbox__intnet: "BB2_W2"
    machine.vm.provision "shell", path:"provisioning/basic-quagga-WWW2.sh"
  end

end

