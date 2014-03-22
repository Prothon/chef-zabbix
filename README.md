zabbix-agent Cookbook
=====================
This cookbook sets up a zabbix client, points it to a zabbix server or proxy, 
and sets the name to be the hostname.

Attributes
----------

Tested and works on:
  '''CentOS 6'''
#### zabbix-agent::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['zabbix-agent']['ipaddress']</tt></td>
    <td>String</td>
    <td>This holds the IP address of the zabbix server.</td>
  </tr>
  <tr>
    <td><tt>['zabbix-agent']['config']</tt></td>
    <td>String</td>
    <td>This is the location of the zabbix config directory.</td>
  </tr>
  <tr>
    <td><tt>['zabbix-agent']['service']</tt></td>
    <td>String</td>
    <td>This is just the service name.</td>
  </tr>
</table>

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Andrew Raymer 
