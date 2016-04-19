lock '3.4.0'
set :application, "NPD"
set :deploy_to, "/home/deployer/NPD"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, "git"
set :repo_url, "git@github.com:fi5hbrains/NPD.git"
set :linked_files, %w{config/database.yml config/secrets.yml public/assets/draft.png public/assets/preview_shadow.png}
set :linked_dirs, %w{log public/uploads public/downloads public/assets/brands public/assets/users public/assets/polish_tmp public/assets/font public/assets/polish_parts}
set :branch, "master"
set :rails_env, "production" #added for delayed job 
set :delayed_job_pid_dir, '/tmp'
set :passenger_restart_with_touch, true

namespace :deploy do
  # %w[start stop restart].each do |command|
  #   desc "#{command} unicorn server"
  #   task command, roles: :app, except: {no_release: true} do
  #     run "/etc/init.d/unicorn_#{application} #{command}"
  #   end
  # end
  
  # task :setup_config, roles: :app do
  #   sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #   # sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  #   run "mkdir -p #{shared_path}/config"
  #   put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
  #   put File.read("config/secrets.example.yml"), "#{shared_path}/config/secrets.yml"
  #   puts "Now edit the config files in #{shared_path}."
  # end
  # after "deploy:setup", "deploy:setup_config"
  
  # task :symlink_config, roles: :app do
  #   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # end
  # after "deploy:finalize_update", "deploy:symlink_config"
  
  # desc "Make sure local git is in sync with remote."
  # task :check_revision, roles: :web do
  #   unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #     puts "WARNING: HEAD is not the same as origin/master"
  #     puts "Run `git push` to sync changes."
  #     exit
  #   end
  # end

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  
  # before "deploy", "deploy:check_revision"
  
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
  
  #delayed_job
  # after "deploy:stop",    "delayed_job:stop"
  # after "deploy:start",   "delayed_job:start"
  # after "deploy:restart", "delayed_job:restart"
end

# # config valid only for current version of Capistrano
# lock '3.4.0'
# 
# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'
# 
# # Default branch is :master
# # ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# 
# # Default deploy_to directory is /var/www/my_app_name
# # set :deploy_to, '/var/www/my_app_name'
# 
# # Default value for :scm is :git
# # set :scm, :git
# 
# # Default value for :format is :pretty
# # set :format, :pretty
# 
# # Default value for :log_level is :debug
# # set :log_level, :debug
# 
# # Default value for :pty is false
# # set :pty, true
# 
# # Default value for :linked_files is []
# # set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
# 
# # Default value for linked_dirs is []
# # set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
# 
# # Default value for default_env is {}
# # set :default_env, { path: "/opt/ruby/bin:$PATH" }
# 
# # Default value for keep_releases is 5
# # set :keep_releases, 5
# 
# namespace :deploy do
# 
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end
# 
# end
