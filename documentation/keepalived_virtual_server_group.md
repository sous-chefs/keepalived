
# keepalived_virtual_server_group

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_virtual_server_group` resource can be used to manage configuration within the `virtual_server_group` section of keepalived.conf.

This feature offers a way to simplify your configuration by factorizing virtual server definitions. If you need to define a  bunch  of  virtual  servers  with  exactly  the same real server topology then this feature will make your configuration  much  more  readable  and  will  optimize healthchecking  task by only spawning one healthchecking where multiple virtual server declaration will spawn  a  dedicated  healthchecker  for every real server which will waste system resources.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `vips`      | `Array`     | `[]` | Array of Strings declaring machine IPs + Ports | |
| `fwmarks`   | `Array`     | `[]` | Array of Integers declaring Firewall Marks | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, keepalived_virtual_server_group__#{name}__.conf)` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `virtual_server_group.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_virtual_server_group 'http' do
  vips ['192.168.1.13 80', '192.168.1.14 80']
  notifies :restart, 'service[keepalived]', :delayed
end
```
