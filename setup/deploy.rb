# Quick Reference
# Configure the essential configurations below and do the following:
#
#   For more information:
#   http://github.com/meskyanichi/deployer 
#
#   Create Local and Remote Repository:
#     git init
#     cap deploy:repository:create
# 
#   Initial Deployment:
#     git add .
#     git commit -am "Initial commit for deployment"
#     git push origin master
#     cap deploy:initial
#     
#   Then For Every Update Just Do:
#     git add .
#     git commit -am "some other commit"
#     git push origin master
#     cap deploy
#
#   For Apache2 Users
#     cap deploy:apache:create
#     cap deploy:apache:destroy
#     cap deploy:apache:restart
#     cap deploy:apache:destroy_all
#
#   For NginX Users
#     cap deploy:nginx:create
#     cap deploy:nginx:destroy
#     cap deploy:nginx:restart
#     cap deploy:nginx:destroy_all
#
#   For a Full List of Commands
#     cap -T


# Essential Configuration
# Assumes Application and Git Repository are located on the same server
set :ip,          "123.45.678.90" # the ip address that points to your production server
set :user,        "root"          # the user that will connect to the production server
set :remote,      "origin"        # the remote that should be deployed
set :branch,      "master"        # the branch that should be deployed
set :domain,      "example.com"   # (or   set :domain,    "subdomain.example.com"
set :subdomain,   false           # and   set :subdomain, true)

# Optional
# If the Git Repository resides/should reside on a different server than where the application deploys,
# then uncomment the following line and specify the repository_url/user
# NOTE: The Tasks "cap deploy:repository:create/destroy/reset" won't work if you use this!
# You will have to manually create the repository yourself on the specified server.
#
# set :repository_url,  "root@example.com:/path/to/repository.git"


# Set up additional shared folders
set :additional_shared_folders,
  %w(public/assets db)

# Set up additional shared symlinks
# These are mirrored to the Rails Applications' structure
# public/assets         = RAILS_ROOT/public/assets          => SHARED_PATH/public/assets
# db/production.sqlite3 = RAILS_ROOT/db/production.sqlite3  => SHARED_PATH/db/production.sqlite3
set :additional_shared_symlinks,
  %w(public/assets db/production.sqlite3)


# Additional Application Specific Tasks and Callbacks
# In here you can specify which Application Specific tasks you would like to run right before the application
# re-sets permissions and restarts passenger. You invoke the by simply calling "run_custom_task".
#
def after_deploy
  run_custom_task "my_custom_task"
  run_custom_task "nested:my_custom_task"
end

# Application Specific Deployment Tasks
# In here you may specify any application specific and/or other tasks that are not handled by Deployer
namespace :deploy do  
  desc "This is my custom task."
  task :my_custom_task do
    run "ls -la #{shared_path}"
  end
  
  namespace :nested do
    desc "This is my nested custom task."
    task :my_custom_task do
      system "ls -la"
    end
  end
end


# Default Configuration Apache/NginX
# The settings below are default, you do not need to set these, unless you want to specify other parameters.
# If you find that the settings below are fine, then you can leave them commented out or just remove them.
# 
# set :apache_initialize_utility_path,  '/etc/init.d/apache2'             # Only applies if running Apache and using the Apache Tasks
# set :apache_sites_available_path,     '/etc/apache2/sites-available'    # Only applies if running Apache and using the Apache Tasks
# set :nginx_initialize_utility_path,   '/etc/init.d/nginx'               # Only applies if running NginX and using the NginX Tasks
# set :nginx_sites_enabled_path,        '/opt/nginx/conf/sites-enabled'   # Only applies if running NginX and using the NginX Tasks