require 'term/ansicolor'
include Term::ANSIColor
class String
  include Term::ANSIColor
end
require 'terminal-table'

namespace :validate do

  desc "Validate the state of a node after deploy"
  task :'validate-deploy' do
    table = Terminal::Table.new
    table.title = "Capistrano Deployment Checks".yellow
    table.headings = ["Check".bold, "Result".bold]

    on roles(:db) do |host|
      print "\n[Devellocus Pipeline]".bold.blue, " Checking dependencies after cooking #{host.hostname} with user #{host.user}".bold, "\n"

      check = 'Database running'
      formula = 'mysqladmin -u root status 2>&1'
      returned = capture(formula)
      match = returned.match /^Uptime\: \d+/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_row [check, result]
      puts ""
      puts ""
      puts table
      puts ""
      puts ""
    end

    on roles(:app) do |host|
      print "\n[Devellocus Pipeline]".bold.blue, " Checking dependencies after cooking #{host.hostname} with user #{host.user}".bold, "\n"

      check = 'Ruby installed'
      formula = 'ruby -v 2>&1'
      returned = capture(formula)
      match = returned.match /^ruby/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'Rails installed'
      formula = 'rails -v 2>&1'
      returned = capture(formula)
      match = returned.match /^Rails/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'rubygems installed'
      formula = 'gem -v 2>&1'
      returned = capture(formula)
      match = returned.match /^\d+.\d+.\d+/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'Bundler installed'
      formula = 'bundle -v 2>&1'
      returned = capture(formula)
      match = returned.match /^Bundler version/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'User group exists'
      formula = "grep -E '^deployer\:x\:[0-9]\+\:.*deploy' /etc/group"
      returned = capture(formula)
      match = returned.match /deployer\:x\:\d+\:deploy/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'User exists'
      formula = "grep 'deploy' /etc/passwd 2>&1"
      returned = capture(formula)
      match = returned.match /deploy/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'Deploy permissions exist'
      formula = 'ls /etc/sudoers.d/deploy_permissions 2>&1'
      formula = 'test("[ -e /etc/sudoers.d/deploy_permissions ]")'
      returned = ''
      result = ''
      as :root do
        returned = capture(:ls, "/etc/sudoers.d/deploy_permissions 2>&1")
      end
      match = returned.match /\/etc\/sudoers.d\/deploy_permissions/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      check = 'SSH keys authorized'
      formula = 'ls /home/deploy/.ssh/authorized_keys 2>&1'
      returned = capture(formula)
      match = returned.match /\/home\/deploy\/.ssh\/authorized_keys/
      result = "successful".green if match
      result = "failed".red if !match
      table.add_separator
      table.add_row [check, result]

      puts ""
      puts ""
      puts table
      puts ""
      puts ""
    end
  end

end
