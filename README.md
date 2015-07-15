#README

##This is a default environment to start a Ruby on Rails w/ Angular project using a Vagrant instance.

###Installation:
1. Download latest version of Vagrant https://www.vagrantup.com/downloads.html
2. open up your terminal:
3. <tt>vagrant box add ubuntu/trusty64</tt> (downloads VM, may take a while)
4. <tt>git clone https://github.com/lechegaray/vagrantrails.git</tt> downloads our preconfigured environment
5. <tt>cd vagrantrails</tt>
6. <tt>rm -rf .git </tt> removes the repo so it doesnt interfere with the vagrant's app git
7. <tt>vagrant up</tt> creates the vagrant instance
8. <tt>vagrant ssh</tt>
9. <tt>git clone https://github.com/devellocus/almapp.git</tt>
10. <tt>cd almapp</tt> (moves into our application directory)
11. <tt>bundle install</tt>
12. <tt>rake db:create</tt> connects rails to mysql
13. <tt>rake bower:install</tt> uses bower to install all dependencies (generates vendor/assets/.bowerrc file, if there are any permission errors delete this file and rerun command)
14. <tt>rails s -b 0.0.0.0</tt> starts out server
15. On the host machine, navigate to localhost:3000

##YOU SHOULD COMMIT FROM INSIDE THE VAGRANT INSTANCE*
* you make have to set your username and email before you can commit anything*
* look below for installing your keys to your github profile*

##SSH KEY IN YOUR GITHUB PROFILE:
* sudo root 
* cd ~/.ssh/id_rsa go to here (inside the vagrant vm)
* copy key out of this file
* https://github.com/settings/ssh
* Add SSH key
* Now commit and push (you may have to enter your email and name the first time)