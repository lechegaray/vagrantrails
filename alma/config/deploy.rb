SSHKit.config.command_map[:rake] = "bundle exec rake" # Ensure that bundle is used for rake tasks
lock '3.1.0' # config valid only for Capistrano 3.1

set :application, 'almapp'
set :deploy_to, "/var/www/#{fetch(:application)}"
set :use_sudo, true # should this be false since our user owns target locations?
set :pty, false
set :keep_releases, 5
set :format, :pretty
set :log_level, :debug
set :repo_url, 'git@github.com:devellocus/almapp.git'
set :scm, :git
set :branch, "master"
set :deploy_group, "deployer"
set :bundle_without, %w{development}.join(' ') # default is %w{development test}
set :bundle_flags, '--local --deployment' # default is '--deployment --quiet', '--local' uses gems in vendor/cache
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 } # NOKOGIRI_USE_SYSTEM_LIBRARIES=1 when executed

namespace :deploy do

  before :starting, 'diagnostics:timestamp'
  #before :starting, 'configure:instance'
  #before :starting, 'configure:test_db_setup'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Restarts Phusion Passenger
      # if not Passenger app ...
      #   DeployHelpers.restart_rails
      # else
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do |host|
  #     DeployHelpers.restart_rails
  #   end
  # end
  #
  # after :publishing, :restart
  #
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #   end
  # end

  after :finishing, 'deploy:cleanup'
  after :finished, 'validate:validate-deploy'
  after :finished, 'diagnostics:timestamp'

  # class DeployHelpers
  #
  #   def self.rails_process
  #     running_process = ''
  #     on roles(:app), in: :sequence, wait: 5 do |host|
  #       begin
  #         running_process = capture("ps -u deploy -F | grep  -E '/home/deploy/.+/bin/ruby bin/rails server -e #{fetch(:rails_env)}' | grep -v grep")
  #       rescue
  #         # consume error when grep returns nothing ... which seems wrong
  #       end
  #     end
  #     running_process
  #   end
  #
  #   def self.rails_running?
  #     running = false
  #     on roles(:app), in: :sequence, wait: 5 do |host|
  #       running = DeployHelpers.rails_process =~ /^deploy/
  #     end
  #     running
  #   end
  #
  #   def self.start_rails
  #     on roles(:app), in: :sequence, wait: 5 do |host|
  #       puts "\n[Devellocus Pipeline]".bold.cyan + " Starting Rails server for environment #{fetch(:rails_env)}".bold.green
  #       within "#{release_path}" do
  #         execute :rails, :server, "-e #{fetch(:rails_env)} -d"
  #       end
  #     end
  #   end
  #
  #   def self.restart_rails
  #     on roles(:app), in: :sequence, wait: 5 do |host|
  #       if DeployHelpers.rails_running?
  #         puts "\n[Devellocus Pipeline]".bold.cyan + " Rails was running, so restarting".bold.green
  #         puts "==> Finding Rails server process ID (pid) with grep".bold
  #         current_server_process_id = DeployHelpers.rails_process.match(/^deploy\s+(\d+)/)[1]
  #         puts "==> Killing pid " + "#{current_server_process_id}".bold.yellow
  #         execute :kill, "#{current_server_process_id}"
  #         puts "==> Restarting Rails server in the background for environment ".bold + "#{fetch(:rails_env)}".bold.yellow
  #       else
  #         puts "\n[Devellocus Pipeline]".bold.cyan + " Rails wasn't running, so starting cold".bold.green
  #       end
  #       DeployHelpers.start_rails
  #     end
  #   end
  # end

end
