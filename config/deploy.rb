# capistranoの出力がカラーになる
require 'capistrano_colors'

# cap deploy時に自動で bundle install が実行される
require "bundler/capistrano"

# RVMを利用している場合は必要
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '2.0.0p353'
set :rvm_type, :user
set :rvm_bin_path, "/usr/local/rvm/bin/"
set :rvm_type, :system
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :application, "muse_server"
#set :repository,  "git@github.com:SmileZero/muse_server.git"#https://github.com/SmileZero/muse_server.git
set :repository, "https://github.com/SmileZero/muse_server.git"
set :branch, "release"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"

set :scm, :git
set :scm_command, :git
set :use_sudo, false

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa.pub')],
  forward_agent: true,
  auth_methods: %w(publickey)
}

#role :web, "rackhuber@muse-01.rackbox.net:50108"  #デプロイ先SSHポートを指定（デフォルトは22）
#role :app, "rackhuber@muse-01.rackbox.net:50108"
#role :db,  "rackhuber@muse-01.rackbox.net:50108", :primary => true

role :web, "172.30.4.19:10022"
role :app, "172.30.4.19:10022"
role :db, "172.30.4.19:10022"

set :unicorn_pid, "/tmp/unicorn_#{application}.pid"
set :unicorn_config, "#{current_path}/config/unicorn.rb" 


namespace :deploy do
  desc "Start Application" 
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path}; bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end
  desc "Stop Application" 
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "test -f #{unicorn_pid}; kill `cat #{unicorn_pid}` || echo 'skip'" 
  end
  desc "Stop Application gracefully" 
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "test -f #{unicorn_pid}; kill -s QUIT `cat #{unicorn_pid}` || echo 'skip'" 
  end
  desc "Reload Application" 
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "test -f #{unicorn_pid}; kill -s USR2 `cat #{unicorn_pid}` || echo 'skip'" 
  end
  desc "Restart Application" 
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end

# Rails3.1.1のProduction用
# namespace :assets do
#   task :precompile, :roles => :web do
#     run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
#   end
#   task :cleanup, :roles => :web do
#     run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:clean"
#   end
# end
# after :deploy, "assets:precompile"
