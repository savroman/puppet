#!/bin/bash

###### START INSTALLATION ######

# -- add tools --
APPS=(mc net-tools wget git)

# -- create log file --
mkdir /var/log/vagrant
LOG=/var/log/vagrant/start.log
#exec > $LOG 2>&1
# -- settime time zone --
#ZONE=`grep ZONE /etc/sysconfig/clock`
#if [$ZONE == "*Europe/Kiev*"]
#then
#  echo "Time zone is corect" 1>$LOG
#else
  ping -c 10 8.8.8.8
  rm -fr /etc/localtime
  ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime 2
  yum install -y ntpdate
  ntpdate -u pool.ntp.org
  echo "Time zone is set to Kiev"

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
    systemctl start puppetserver
  fi
else
  yum install puppet-agent -y
  /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
fi
