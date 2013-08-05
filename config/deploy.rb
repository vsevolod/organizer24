#require "bundler/capistrano"
require "rvm/capistrano"
bundle_path = '/home/vsevolod/.rvm/gems/ruby-2.0.0-p247@global/bin/'

set :default_environment, {
  'PATH' => "/home/vsevolod/.rvm/gems/ruby-2.0.0-p247/bin/:$PATH",
  "BUNDLE_PATH" => bundle_path
}
set :bundle_without,  [:development, :test]

set :application, "Organizer24"
set :repository, "git@github.com:vsevolod/organizer24.git"

set :user, "vsevolod"
set :use_sudo, false
set :deploy_via, :export
set :deploy_to, "/home/vsevolod/capistrano/organizer24"
set :scm, :git

role :web, "organizer24.ru"
role :app, "organizer24.ru"
role :db,  "organizer24.ru"

after "deploy:update_code", :copy_config_files
after "deploy:update_code", :add_log_files
after "deploy:update_code", :precompile

task :copy_config_files, roles => :app do
  run "cp #{shared_path}/database.yml #{release_path}/config/database.yml"
  run "cp #{shared_path}/config.yml #{release_path}/config/config.yml"
end

task :add_log_files, roles => :app do
  run "ln -nfs #{shared_path}/log #{release_path}/log"
  run "ln -nfs #{shared_path}/system #{release_path}/system"
end


task :ln_assets do
  run <<-CMD
    rm -rf #{latest_release}/public/assets &&
    mkdir -p #{shared_path}/assets &&
    ln -s #{shared_path}/assets #{latest_release}/public/assets
  CMD
end

task :precompile do
  run_locally "bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets"
  run_locally "cd public; tar -zcvf assets.tar.gz assets"
  top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
  run "cd #{shared_path}; tar -zxvf assets.tar.gz"
  ln_assets
  run_locally "rm public/assets.tar.gz"
  run_locally "rm -rf public/assets"
end

set :rails_env, :production
set :unicorn_binary, "/home/vsevolod/.rvm/gems/ruby-2.0.0-p247/bin/unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "source /home/vsevolod/.rvm/environments/ruby-2.0.0-p247"
    run "cd #{current_path} && /usr/bin/env PATH=$PATH:/usr/local/bin RAILS_ENV=#{rails_env} script/delayed_job start"
    run "cd #{current_path} && #{bundle_path}bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "source /home/vsevolod/.rvm/environments/ruby-2.0.0-p247"
    run "cd #{current_path} && /usr/bin/env PATH=$PATH:/usr/local/bin RAILS_ENV=#{rails_env} script/delayed_job stop"
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
