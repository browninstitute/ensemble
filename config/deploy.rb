require "rvm/capistrano"
require "bundler/capistrano"
require "delayed/recipes"
load "deploy/assets"

set :application, "story-collab"
set :repository,  "https://github.com/StanfordHCI/story-collab.git"

set :scm, :git 
set :branch, "release"
set :user, "ubuntu"
set :use_sudo, true
set :scm_username, "jojo080889"
ssh_options[:keys] = ["/home/jojo080889/Documents/ServerKeys/jojo0808key.pem"]
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :deploy_to, "/var/www/story-collab"
after "deploy", "deploy:migrate"

set :rails_env, "production" # added for delayed_job

role :web, "ensemble.stanford.edu"                          # Your HTTP server, Apache/etc
role :app, "ensemble.stanford.edu"                          # This may be the same as your `Web` server
role :db,  "ensemble.stanford.edu", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# delayed_job
after "deploy:stop", "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :config do
  task :update, :roles => [:app, :web] do
    run "ln -nfs #{shared_path}/config/initializers/devise.rb #{release_path}/config/initializers/devise.rb"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

before "deploy:assets:symlink" do
  config.update
end

after :bundle_install, "deploy:migrate"
