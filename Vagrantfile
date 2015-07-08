# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
  sudo apt-get -y update
  sudo apt-get -y install curl git-core python-software-properties ruby-dev libpq-dev build-essential nginx libsqlite3-0 libsqlite3-dev libxml2 libxml2-dev libxslt1-dev nodejs postgresql postgresql-contrib imagemagick libreadline-dev

  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"'               >> ~/.bashrc
  source ~/.bashrc

  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  sudo -H -u vagrant bash -i -c 'rbenv install 2.1.2'
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
  sudo -H -u vagrant bash -i -c 'rbenv global 2.1.2'
  sudo -H -u vagrant bash -i -c 'gem install bundler --no-ri --no-rdoc'
  sudo -H -u vagrant bash -i -c 'rbenv rehash'
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  # config.vm.provider :virtualbox do |vb|
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end

  config.vm.provision :shell, privileged: false, inline: $script
  config.vm.provision "shell", path: "script.sh"

end