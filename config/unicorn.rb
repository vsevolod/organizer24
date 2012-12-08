deploy_to  = "/home/vsevolod/capistrano/organizer24"
rails_root = "#{deploy_to}/current"
rails_env  = "production"
pid_file   = "#{deploy_to}/shared/pids/unicorn.pid"
socket_file= "#{deploy_to}/shared/unicorn.sock"
log_file   = "#{rails_root}/log/unicorn.log"
username   = "vsevolod"
err_log    = "#{rails_root}/log/unicorn_error.log"
old_pid    = pid_file + '.oldbin'

timeout 200

worker_processes 1

# Listen on a Unix data socket
listen socket_file, :backlog => 1024
pid pid_file
stderr_path err_log
stdout_path log_file

listen 3001, :tcp_nopush => true

preload_app true

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)
before_exec do |server|
     ENV["BUNDLE_GEMFILE"] = "#{rails_root}/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

    if File.exists?(old_pid) && server.pid != old_pid
      begin
        Process.kill("QUIT", File.read(old_pid).to_i)
      rescue Errno::ENOENT, Errno::ESRCH
        ###
      end
    end
end


after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection

  worker.user(username) if Process.euid == 0 && rails_env == 'production'
end
