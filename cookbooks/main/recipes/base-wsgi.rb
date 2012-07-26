node[:wsgi_apps].each do |app|

  execute "apache2ctl stop"
  execute "rm -rf #{app[:parent_path]}#{app[:path]}"
  
  directory "#{app[:parent_path]}#{app[:path]}" do
    owner 'root'
    group 'www-data'
    mode 0754
    recursive true
  end

  directory "#{app[:parent_path]}#{app[:path]}src" do
    owner 'root'
    group 'www-data'
    mode 0754
    recursive true
  end

  directory "#{app[:parent_path]}#{app[:path]}static" do
    owner 'root'
    group 'www-data'
    mode 0754
    recursive true
  end

  cookbook_file "#{app[:parent_path]}#{app[:path]}src/live.wsgi" do
    source "live.wsgi"
    owner 'root'
    group 'www-data'
    mode 0754
  end

  execute "apache2ctl graceful"

end
