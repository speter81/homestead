#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.


# If you're not quite ready for the latest Node.js version,
# uncomment these lines to roll back to a previous version

# Remove current Node.js version:
#sudo apt-get -y purge nodejs
#sudo rm -rf /usr/lib/node_modules/npm/lib
#sudo rm -rf //etc/apt/sources.list.d/nodesource.list

# Install Node.js Version desired (i.e. v13)
# More info: https://github.com/nodesource/distributions/blob/master/README.md#debinstall
#curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
#sudo apt-get install -y nodejs

sudo apt-get install -y php-memcache
sudo systemctl restart php5.6-fpm
sudo systemctl restart php7.2-fpm
sudo systemctl restart php7.3-fpm

# add dev network interfaces (legacy code support)
ifconfig eth0:1 172.27.67.15 netmask 255.255.255.0
ifconfig eth0:2 172.27.67.139 netmask 255.255.255.0
ifconfig eth0:3 172.27.67.104 netmask 255.255.255.0
ifconfig eth0:4 172.27.67.110 netmask 255.255.255.0
ifconfig eth0:5 172.27.67.147 netmask 255.255.255.0
ifconfig eth0:6 172.27.67.17 netmask 255.255.255.0

sudo apt install -y mc

