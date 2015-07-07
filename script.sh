#!/bin/bash --login

cd /vagrant

apt-get install -y git
apt-get install -y libsqlite3-dev
apt-get install -y nodejs

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get update
apt-get install -y mysql-server

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm

rvm requirements
rvm install 2.1.2

bundle install

echo "cd /vagrant" >> /home/vagrant/.bashrc