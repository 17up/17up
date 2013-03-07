# coding: utf-8
require "bundler/capistrano"
require "sidekiq/capistrano"

require "rvm/capistrano"
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"
default_run_options[:pty] = true
set :rvm_ruby_string, 'ruby-2.0.0-p0'
set :rvm_type, :user

set :application, "17up"
set :repository,  "git@github.com:17up/17up.git"
set :branch, "master"
set :scm, :git
set :scm_username, "kkxlkkxllb@gmail.com"
set :keep_releases, 3   # 留下多少个版本的源代码
set :user, "www"
set :deploy_to, "~/#{application}/"
set :runner, "ruby"
set :use_sudo,  false
set :deploy_via, :remote_cache

role :web, "17up.org"                          # Your HTTP server, Apache/etc
role :app, "17up.org"                          # This may be the same as your `Web` server
role :db,  "17up.org", :primary => true # This is where Rails migrations will run

set :rails_env, :production
# unicorn.rb 路径
set :unicorn_path, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  end

  task :stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true }  do
    run "touch #{current_path}/tmp/restart.txt;kill -USR2 `cat #{unicorn_pid}`"
  end
end

namespace :faye do
  desc "Start Faye"
  task :start, :roles => :app do
    run "cd #{deploy_to}/current/faye_server; thin start -C thin.yml"
  end

  desc "Stop Faye"
  task :stop, :roles => :app do
    run "cd #{deploy_to}/current/faye_server; thin stop -C thin.yml"
  end

  desc "Restart Faye"
  task :restart, :roles => :app do
    run "cd #{deploy_to}/current/faye_server; thin restart -C  thin.yml"
  end
end


task :init_shared_path, :roles => :web do
  run "mkdir -p #{deploy_to}/shared/log"
  run "mkdir -p #{deploy_to}/shared/pids"
  run "mkdir -p #{deploy_to}/shared/assets"
end

task :link_shared_files, :roles => :web do
  run "ln -sf #{deploy_to}/shared/config/*.yml #{deploy_to}/current/config/"
  run "ln -sf #{deploy_to}/shared/config/unicorn.rb #{deploy_to}/current/config/"
end

task :mongoid_create_indexes, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake db:mongoid:create_indexes"
end

task :compile_assets, :roles => :web do
  #run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:precompile"
  run "cd #{release_path} && bundle exec rake RAILS_ENV=production RAILS_GROUPS=assets assets:clean assets:precompile"      
end

#task :sync_assets_to_cdn, :roles => :web do
#  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:cdn"
#end

task :mongoid_migrate_database, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake db:migrate"
end

after "deploy:finalize_update","deploy:symlink", :init_shared_path, :link_shared_files, :compile_assets#, :sync_assets_to_cdn, :mongoid_migrate_database
after "deploy:restart", "deploy:cleanup"
