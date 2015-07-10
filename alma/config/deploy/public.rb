set :stage, :public
set :rails_env, 'production'
set :user, 'deploy'
set :default_initial_user_on_target, 'ubuntu'
set :ssh_options, { forward_agent: true }
server 'ec2-52-2-65-17.compute-1.amazonaws.com', user: 'deploy', roles: %w{web app}, primary: true, keys: ['~/.ssh/pipeline.pem']
