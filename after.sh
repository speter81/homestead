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
sudo apt install -y php5.6-memcache

sudo systemctl restart php5.6-fpm
sudo systemctl restart php7.2-fpm
sudo systemctl restart php7.3-fpm

sudo apt autoremove

sudo update-alternatives --set php /usr/bin/php7.2

sudo chown -R vagrant:vagrant /var/lib/php/sessions

if [ -f /etc/netplan/60-custom.yaml ]
then
    echo "custom network already installed."
    exit 0
fi

customNetwork="---
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
      - 172.27.67.15/24
      - 172.27.67.139/24
      - 172.27.67.104/24
      - 172.27.67.110/24
      - 172.27.67.147/24
      - 172.27.67.17/24
"

echo "$customNetwork" > 60-custom.yaml
sudo mv 60-custom.yaml /etc/netplan/60-custom.yaml
sudo chmod 644 /etc/netplan/60-custom.yaml
sudo chown root:root /etc/netplan/60-custom.yaml

sudo netplan apply
