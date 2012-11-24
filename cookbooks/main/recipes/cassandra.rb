package "openjdk-7-jdk"

apt_repository "datastax" do
  uri          "http://debian.datastax.com/community"
  distribution "stable"
  components   ["main"]
  key          "http://debian.datastax.com/debian/repo_key"

  action :add
end

package "python-cql" do
  action :install
end

package "dsc" do
  action :install
end

service "cassandra" do
  supports :restart => true, :status => true
  action [:enable, :start]
end
