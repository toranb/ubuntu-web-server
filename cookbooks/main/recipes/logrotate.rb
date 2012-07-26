node[:wsgi_apps].each do |app|
	logrotate_app "apache" do
		cookbook "logrotate"
		path "#{app[:parent_path]}#{app[:logs_dir]}"
		frequency "daily"
		rotate 100
		create "774 #{app[:owner]} www-data"
	end
end
