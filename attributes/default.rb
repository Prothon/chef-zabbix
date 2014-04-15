default['zabbix']['server']['ipaddress'] = "10.13.37.24"
default['zabbix']['client']['config'] = "/etc/zabbix/"
default['zabbix']['client']['service'] = "zabbix-agent"

default['zabbix']['server']['packages'] = %w(zabbix-server-mysql zabbix-web-mysql zabbix-agent mysql-server sendmail)
default['zabbix']['server']['service'] = "zabbix-server"

default['zabbix']['mysql']['ipaddress'] = "127.0.0.1"
default['zabbix']['mysql']['username'] = "root"
default['zabbix']['mysql']['password'] = "secret"
default['zabbix']['mysql']['port'] = "3306"
default['zabbix']['mysql']['dbname'] = "zabbix"