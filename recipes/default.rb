#
# Cookbook Name:: zabbix-agent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
cookbook_file "/etc/yum.repos.d/zabbix.repo" do
    source "zabbix.repo"
    mode "0644"
end

package "#{node['zabbix']['service']}" do
    action :install
end

template "#{node['zabbix']['config']}/zabbix_agentd.conf" do
    source "zabbix_agentd.conf.erb"
    mode "0644"
    owner = "root"
    group = "root"
    notifies :restart, "service[zabbix-agent]", :immediately
end

service "#{node['zabbix']['service']}" do
    action [ :enable, :start ]
end