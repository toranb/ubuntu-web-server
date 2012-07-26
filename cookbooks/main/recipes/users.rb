if node[:users]
    execute "chmod 705 /root"
    node[:users].each_pair do |username, info|
        home_dir = "/root/#{username}"

        user username do 
            password info[:password]
        end

        directory "#{home_dir}" do
            owner username
            group username
            mode 0700
            recursive true
        end

        user username do 
            home home_dir
        end

        info[:groups].each do |name|
            group name do
                members [username]
            end
        end

        auto_sudo = "#{username} ALL=(ALL) NOPASSWD: ALL"
        execute "cat /etc/sudoers | grep '#{auto_sudo}' || $(echo '#{auto_sudo}' >> /etc/sudoers)"

        execute "rm -rf #{home_dir}/.ssh"
        directory "#{home_dir}/.ssh" do
            owner username
            group username
            mode 0700
            recursive true
        end
   end
end
