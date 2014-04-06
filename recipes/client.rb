include_recipe 'chef-zabbix::repo'

package "#{node['zabbix']['client']['service']}" do
    action :install
end

template "#{node['zabbix']['client']['config']}/zabbix_agentd.conf" do
    source "zabbix_agentd.conf.erb"
    mode "0644"
    owner = "root"
    group = "root"
    notifies :restart, "service[zabbix-agent]", :immediately
end

service "#{node['zabbix']['client']['service']}" do
    action [ :start, :enable ]
end