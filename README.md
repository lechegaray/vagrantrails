#README

###This is a default environment to start a Ruby on Rails w/ Angular project using a Vagrant instance.

####Installation:
* Download latest version of Vagrant https://www.vagrantup.com/downloads.html
* open up your terminal:
* <tt>vagrant box add ubuntu/trusty64</tt> (downloads VM, may take a while)
* <tt>git clone https://github.com/lechegaray/vagrantrails.git</tt> downloads our preconfigured environment
* <tt>cd vagrantrails</tt>
* <tt>vagrant up</tt> creates the vagrant instance
* <tt>vagrant ssh</tt>
* <tt>git clone https://github.com/devellocus/almapp.git</tt>
* <tt>cd almapp</tt> (moves into our application directory)
* <tt>bundle install</tt>
* <tt>rake db:create</tt> connects rails to mysql
* <tt>rake db:migrate</tt>
* <tt>rails s -b 0.0.0.0</tt> starts out server
* On the host machine, navigate to localhost:3000

###YOU SHOULD COMMIT FROM INSIDE THE VAGRANT INSTANCE
* you make have to set your username and email before you can commit anything
* look below for installing your keys to your github profile

###SSH KEY IN YOUR GITHUB PROFILE:
* sudo root 
* cd ~/.ssh/id_rsa go to here (inside the vagrant vm)
* copy key out of this file
* https://github.com/settings/ssh
* Add SSH key
* Now commit and push (you may have to enter your email and name the first time)