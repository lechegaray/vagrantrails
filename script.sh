#!/bin/bash --login

cd /vagrant

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y update
sudo apt-get -y install -y mysql-server

echo "cd /vagrant" >> /home/vagrant/.bashrc