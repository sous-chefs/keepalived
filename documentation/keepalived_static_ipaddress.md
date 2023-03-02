
# keepalived_static_ipaddress

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_static_ipaddress` resource can be used to manage configuration within the `static_ipaddress` section of keepalived.conf.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `addresses` | `Array`       | `nil` | (Required) A list of IP Address declarations | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, 'static_ipaddress.conf')` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `static_ipaddress.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_static_ipaddress 'static_ipaddress' do
  addresses [
    '192.168.1.98/24 dev eth0 scope global',
    '192.168.1.99/24 dev eth0 scope global',
  ]
  notifies :restart, 'service[keepalived]', :delayed
end
```
