include_recipe 'chef-zabbix::repo'
include_recipe 'chef-zabbix::client'
include_recipe 'chef-httpd::basic'

node['zabbix']['server']['packages'].each do |zabbixpkgs|
    package zabbixpkgs
end

service "mysqld" do
    action [:enable, :start]
end
# Right now it expects that the db is fresh and on the local machine
execute "set-mysql-password" do
    command "mysqladmin -h #{node['zabbix']['mysql']['ipaddress']} -u #{node['zabbix']['mysql']['username']} password #{node['zabbix']['mysql']['password']}"
    notifies :create, "ruby_block[flag_set_mysql_password]", :immediately
    not_if { node.attribute?("set_mysql_password") }
end

ruby_block "flag_set_mysql_password" do
  block do
    node.set['set_mysql_password'] = true
    node.save
  end
  action :nothing
end

execute "build-db" do
    command "mysql -h #{node['zabbix']['mysql']['ipaddress']} -u #{node['zabbix']['mysql']['username']} -p#{node['zabbix']['mysql']['password']} -e \"create database #{node['zabbix']['mysql']['dbname']} character set utf8 collate utf8_bin;\""
    notifies :create, "ruby_block[flag_build_db]", :immediately
    not_if { node.attribute?("built_db") }
end

ruby_block "flag_build_db" do
  block do
    node.set['built_db'] = true
    node.save
  end
  action :nothing
end

execute "create-schema" do
    command "mysql -h #{node['zabbix']['mysql']['ipaddress']} -u #{node['zabbix']['mysql']['username']} -p#{node['zabbix']['mysql']['password']} #{node['zabbix']['mysql']['dbname']} < /usr/share/doc/zabbix-server-mysql-2.0.11/create/schema.sql"
    notifies :create, "ruby_block[flag_create_schema]", :immediately
    not_if { node.attribute?("created_schema") }
end

ruby_block "flag_create_schema" do
  block do
    node.set['created_schema'] = true
    node.save
  end
  action :nothing
end

execute "create-images" do
    command "mysql -h #{node['zabbix']['mysql']['ipaddress']} -u #{node['zabbix']['mysql']['username']} -p#{node['zabbix']['mysql']['password']} #{node['zabbix']['mysql']['dbname']} < /usr/share/doc/zabbix-server-mysql-2.0.11/create/images.sql"
    notifies :create, "ruby_block[flag_create_images]", :immediately
    not_if { node.attribute?("created_images") }
end

ruby_block "flag_create_images" do
  block do
    node.set['created_images'] = true
    node.save
  end
  action :nothing
end

execute "create-data" do
    command "mysql -h #{node['zabbix']['mysql']['ipaddress']} -u #{node['zabbix']['mysql']['username']} -p#{node['zabbix']['mysql']['password']} #{node['zabbix']['mysql']['dbname']} < /usr/share/doc/zabbix-server-mysql-2.0.11/create/data.sql"
    notifies :create, "ruby_block[flag_create_data]", :immediately
    not_if { node.attribute?("created_data") }
end

ruby_block "flag_create_data" do
  block do
    node.set['created_data'] = true
    node.save
  end
  action :nothing
end

template "/etc/php.ini" do
    source "php.ini.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[httpd]", :immediately
end

template "/etc/httpd/conf.d/zabbix.conf" do
    source "zabbix.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[httpd]", :immediately
end

service "#{node['zabbix']['server']['service']}" do
    action [:enable, :start]
end

template "/etc/zabbix/zabbix_server.conf" do
    source "zabbix_server.conf.erb"
    mode "0644"
    owner "root"
    group "root"
end

template "/etc/zabbix/web/zabbix.conf.php" do
    source "zabbix.conf.php.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :restart, "service[zabbix-server]", :immediately
end

execute "apache-setbool" do
    command "setsebool -P httpd_can_network_connect=true"
    notifies :restart, "service[zabbix-server]", :immediately
    notifies :create, "ruby_block[flag_apache_setbool]", :immediately
    not_if { node.attribute?("bool_set") }
end

ruby_block "flag_apache_setbool" do
  block do
    node.set['bool_set'] = true
    node.save
  end
  action :nothing
end