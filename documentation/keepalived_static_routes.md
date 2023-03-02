
# keepalived_static_routes

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_static_routes` resource can be used to manage configuration within the `static_routes` section of keepalived.conf.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `addresses` | `Array`       | `nil` | (Required) A list of IP Address declarations | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, 'static_routes.conf')` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `static_routes.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_static_routes 'static_routes' do
  routes [
    '192.168.2.0/24 via 192.168.1.100 dev eth0',
    '192.168.3.0/24 via 192.168.1.100 dev eth0',
  ]
  notifies :restart, 'service[keepalived]', :delayed
end
```
