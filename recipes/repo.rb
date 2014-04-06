cookbook_file "/etc/yum.repos.d/zabbix.repo" do
    source "zabbix.repo"
    mode "0644"
end