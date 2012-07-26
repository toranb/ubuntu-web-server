
package "mysql-server"

service "mysql" do
    service_name "mysql"
    restart_command "/usr/sbin/invoke-rc.d mysql restart && sleep 5"
    action :enable
end

execute "preseed mysql-server" do
	command "debconf-set-selections mysql-server.seed"
	action :nothing
end

template "mysql-server.seed" do
	source "mysql-server.seed.erb"
	owner "root"
	group "root"
	mode "0600"
	notifies :run, resources(:execute => "preseed mysql-server"), :immediately
end

cookbook_file "/etc/mysql/my.cnf" do
    source "my.cnf"
    notifies :restart, resources(:service => :mysql)
end

if `mysql -u root -e 'select NOW();' 2>&1 | grep -v 'using password: NO'`.strip != ''
	execute "mysqladmin -u root password #{node[:mysql][:rootpw]}"
end

node[:mysql][:clients].each_pair do |db_name, client| 	
    execute "mysql -u root --password=#{node[:mysql][:rootpw]} -e \"create database if not exists #{db_name};\""
    execute "mysql -u root --password=#{node[:mysql][:rootpw]} -e \"grant all on #{db_name}.* to '#{client[:remote_user]}'@'#{client[:remote_ip]}' identified by '#{client[:remote_userpw]}';\""
end
