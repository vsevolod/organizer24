set :application, "Organizer24"
set :repository, "https://github.com/vsevolod/organizer24.git"

set :user, "vsevolod"
set :use_sudo, false
set :deploy_via, :export
set :deploy_to, "/home/vsevolod/capistrano/organizer24"
set :scm, :git

role :web, "organizer24.ru"
role :app, "organizer24.ru"
role :db,  "organizer24.ru"

after "deploy:update_code", :copy_database_config
after "deploy:update_code", :add_log_files

task :copy_database_config, roles => :app do
  run "cp #{shared_path}/database.yml #{release_path}/config/database.yml"
end

task :add_log_files, roles => :app do
  run "ln -nfs #{shared_path}/log #{release_path}/log"
  run "ln -nfs #{shared_path}/system #{release_path}/system"
end

set :rails_env, :production
set :unicorn_binary, "/home/vsevolod/.rvm/gems/ruby-1.9.3-p327/gems/unicorn-4.5.0/bin/unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
