directory "/etc/node/" do
    owner 'root'
    group 'www-data'
    mode 0755
    recursive true
end

template "jsfile" do
    path "/etc/node/nodeHttpProxy.js"
    source "nodeHttpProxy.erb"
    variables :node_apps => node[:node_apps]
    owner "root"
    group "www-data"
    mode 0755
end

cookbook_file "/etc/node/package.json" do
    source "package.json"
end

cookbook_file "/etc/init/express.conf" do
    source "express.conf"
end

execute "cd /etc/node && npm install"
execute "cd /var/log && touch node.log && chmod 765 node.log && chown -R root:www-data node.log"
execute "iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8000"
execute "iptables-save > /etc/iptables.rules"

cookbook_file "/etc/network/if-post-down.d/iptablessave" do
    source "iptablessave"
end

cookbook_file "/etc/network/if-pre-up.d/iptablesload" do
    source "iptablesload"
end

execute "chmod +x /etc/network/if-post-down.d/iptablessave"
execute "chmod +x /etc/network/if-pre-up.d/iptablesload"
