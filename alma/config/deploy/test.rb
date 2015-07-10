set :stage, :test
set :rails_env, 'test'
set :user, 'deploy'
set :default_initial_user_on_target, 'ubuntu'
set :ssh_options, { forward_agent: true }
server 'ec2-54-210-176-20.compute-1.amazonaws.com', user: 'deploy', roles: %w{web app db}, primary: true, keys: ['~/.ssh/pipeline.pem']
