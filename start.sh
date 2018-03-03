#!/bin/bash

###### START INSTALLATION ######

# -- add tools --
APPS=(mc net-tools wget git ntp ntpdate)

# -- create log file --
mkdir /var/log/vagrant
LOG=/var/log/vagrant/start.log
#exec > $LOG 2>&1

# -- add basic tools to VM --
yum update -y

# -- install apps --
for i in ${APPS[@]}; do
  if yum list installed $i; then
    echo "$i already installed"
  else
    yum install $i -y
  fi
done

# -- set timezone --
timedatectl set-timezone Europe/Kiev
ntpdate pool.ntp.org
NTP_CONF=/etc/ntp.conf
cat >> $NTP_CONF <<EOF
server 0.ua.pool.ntp.org
server 1.ua.pool.ntp.org
server 2.ua.pool.ntp.org
server 3.ua.pool.ntp.org
EOF
systemctl restart ntpd
systemctl enable ntpd
echo "Time zone is set to Kiev"

# -- edit hosts --
HOST_FILE=/etc/hosts
if grep -q "puppet.local" $HOST_FILE; then
  echo "$HOST_FILE is already changed"
else
  cat >> $HOST_FILE <<EOF
192.168.56.150	puppet.local  puppet
192.168.56.151	agent001.local  agent001
192.168.56.152	agent002.local  agent002
EOF
fi
# -- add Puppet repository --
rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
# puppet installation
# TODO
if [[ $(hostname) == puppet ]]; then
  if [[ $(puppetserver -v) == "puppetserver version"* ]]; then
    echo "puppet is already installed"
  else
    yum install puppetserver -y
    sed -i 's|-Xms2g -Xmx2g|-Xms512m -Xmx512m|g' /etc/sysconfig/puppetserver
    sudo iptables -A INPUT -p tcp -m tcp --dport 8140 -j ACCEPT
    systemctl start puppetserver
    systemctl enable puppetserver
  fi
else
  yum install puppet-agent -y
  /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
fi
