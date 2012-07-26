if node[:users]
    node[:users].each_pair do |username, info|

      home_dir = info[:home]
      execute "rm -rf #{home_dir}.ssh"

      directory "#{home_dir}.ssh" do
          owner username
          group username
          mode 0764
          recursive true
      end

      cookbook_file "#{home_dir}.ssh/id_rsa.pub" do
          source info[:public_key]
          owner username
          group username
          mode 0764
      end

      cookbook_file "#{home_dir}.ssh/id_rsa" do
          source info[:private_key]
          owner username
          group username
          mode 0764
      end

    end
end
