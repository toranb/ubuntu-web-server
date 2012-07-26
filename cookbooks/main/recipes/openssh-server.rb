package "openssh-server"

template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    variables :port => node[:ssh_port]
end
