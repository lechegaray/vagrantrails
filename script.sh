#!/bin/bash --login

cd /vagrant

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y update
sudo apt-get -y install -y mysql-server

echo "Creating non-root user for app ..."
echo "CREATE USER 'almappdbuser'@'localhost' IDENTIFIED BY 'dvl_123'" | mysql -uroot -proot
echo "GRANT CREATE ON *.* TO 'almappdbuser'@'localhost'" | mysql -uroot -proot
echo "flush privileges" | mysql -uroot -proot

# echo "Creating databases ..."
# echo "CREATE DATABASE almapp_development" | mysql -uroot -proot
# echo "GRANT ALL ON almapp_development.* TO 'almappdbuser'@'localhost'" | mysql -uroot -proot
# echo "flush privileges" | mysql -uroot -proot

# echo "CREATE DATABASE almapp_test" | mysql -uroot -proot
# echo "GRANT ALL ON almapp_test.* TO 'almappdbuser'@'localhost'" | mysql -uroot -proot
# echo "flush privileges" | mysql -uroot -proot

# echo "CREATE DATABASE almapp_production" | mysql -uroot -proot
# echo "GRANT ALL ON almapp_production.* TO 'almappdbuser'@'localhost'" | mysql -uroot -proot
# echo "flush privileges" | mysql -uroot -proot

cd alma
sudo npm install -g bower
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

echo "cd /vagrant" >> /home/vagrant/.bashrc