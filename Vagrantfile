# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  # Base VM's config
  config.vm.box = "centos/7"
  config.vm.provision "shell",  path: "start.sh"
  config.vm.define "pm" do |ms|
    ms.vm.hostname = 'puppet'
    ms.vm.network "private_network", ip: "192.168.56.150"
    ms.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "PM"
    end
  end

  config.vm.define "web1" do |ag|
    ag.vm.hostname = 'agent001'
    ag.vm.network "private_network", ip: "192.168.56.151"
    ag.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.name = "WEB1"
    end
  end

  config.vm.define "web2" do |ag|
    ag.vm.hostname = 'agent002'
    ag.vm.network "private_network", ip: "192.168.56.152"
    ag.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.name = "WEB2"
    end
  end
end
