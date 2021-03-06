set :application, "news"
set :scm, :git
set :repository,  "git@github.com:caironoleto/noticias-do-piaui.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :user, "news"
set :deploy_to, "/home/news/www/#{application}"
set :use_sudo, false
set :git_enable_submodules, true

role :web, "news.caironoleto.com"
role :app, "news.caironoleto.com"
role :db,  "news.caironoleto.com", :primary => true

task :after_update_code do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
end

namespace :init do
  desc "create database configuration"
  task :database_configuration do
    conf =<<-EOF
production:
  adapter: sqlite3
  database: #{shared_path}/production.sqlite3
  pool: 5
  timeout: 5000
EOF
    run "mkdir -p #{shared_path}/config"
    put conf, "#{shared_path}/config/database.yml"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:setup", "init:database_configuration"