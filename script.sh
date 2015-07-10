#!/bin/bash --login

cd /vagrant

debconf-set-selections <<< 'mysql-server mysql-server/root_password password dvl_123'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password dvl_123'
sudo apt-get -y update
sudo apt-get -y install -y mysql-server

cd alma
sudo npm install -g bower
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

echo "cd /vagrant" >> /home/vagrant/.bashrc