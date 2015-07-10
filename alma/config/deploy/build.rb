set :stage, :build
set :rails_env, 'test'
set :user, 'deploy'
set :default_initial_user_on_target, 'ubuntu'
set :ssh_options, { forward_agent: true }
server 'ec2-52-4-236-30.compute-1.amazonaws.com', user: 'deploy', roles: %w{ci web app db}, primary: true, keys: ['~/.ssh/pipeline.pem']
