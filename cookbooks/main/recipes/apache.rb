package "apache2"
package "libapache2-mod-wsgi"

baseline_virtualenv = "/etc/apache2/baseline_virtualenv"
execute "virtualenv #{baseline_virtualenv} --no-site-packages"

service "apache2" do
    service_name "apache2"
    restart_command "apache2ctl configtest 2>&1 | grep 'warning|error' -iP || (service apache2 restart && sleep 1)"
    action :enable
end

template "apache2.conf" do
    path "/etc/apache2/apache2.conf"
    source "apache2.conf.erb"
    variables :baseline_virtualenv => baseline_virtualenv
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "apache2")
end

execute "rm -rf /etc/apache2/sites-enabled/*"
node[:wsgi_apps].each do |app|

    template "site" do
        path "/etc/apache2/sites-available/#{app[:name]}"
        source "apache-site.erb"
        variables :app => app
        owner "root"
        group "root"
        mode 0644
        notifies :restart, resources(:service => "apache2")
    end
    execute "a2ensite #{app[:name]}"

    directory "#{app[:parent_path]}" do
        owner app[:owner]
        group app[:owner]
        mode 0755
        recursive true
    end
	
    directory "#{app[:parent_path]}#{app[:logs_dir]}" do
        owner 'root'
        group 'www-data'
        mode 0774
        recursive true
    end
    
end
