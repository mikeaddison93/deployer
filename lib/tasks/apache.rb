# apache_initialize_utility_path
# apache_sites_available_path

namespace :deploy do
  namespace :apache do
    
    desc "Adds Apache2 configuration and enables it."
    task :create do
      log "Adding Apache2 Virtual Host for #{domain}"
      config = <<-CONFIG
      <VirtualHost *:80>
        ServerName #{domain}
        #{unless subdomain then "ServerAlias www.#{domain}" end}
        DocumentRoot #{File.join(deploy_to, 'current', 'public')}
      </VirtualHost>
      CONFIG
      
      system 'mkdir tmp'
      file = File.new("tmp/#{domain}", "w")
      file << config
      file.close 
      system "rsync -vr tmp/#{domain} #{user}@#{application}:#{File.join(apache_sites_available_path, domain)}"
      File.delete("tmp/#{domain}")
      run "sudo a2ensite #{domain}"
      run "sudo #{apache_initialize_utility_path} restart"
    end
    
    desc "Restarts Apache2."
    task :restart do
      run "sudo #{apache_initialize_utility_path} restart"
    end
    
    desc "Removes Apache2 configuration and disables it."
    task :destroy do
      log "Removing Apache2 Virtual Host for #{domain}"
      begin run("a2dissite #{domain}"); rescue; end
      begin run("sudo rm #{File.join(apache_sites_available_path, domain)}"); rescue; end
      run("sudo #{apache_initialize_utility_path} restart")
    end

    desc "Destroys Git Repository, Rails Environment and Apache2 Configuration."
    task :destroy_all do
      system "cap deploy:repository:destroy"
      run "rm -rf #{deploy_to}"
      system "cap deploy:apache:destroy"
    end

  end
end