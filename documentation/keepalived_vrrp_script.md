# keepalived_vrrp_script

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_vrrp_script` resource can be used to configure a track script via a `vrrp_script` configuration block.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `script` | `String`       | `nil` | (Required) Path of the script to execute | |
| `interval` | `Integer`       | `nil` | Seconds between script invocations, | |
| `timeout` | `Integer`       | `nil` | Seconds after which script is considered to have failed | |
| `weight` | `Integer`       | `nil` | Adjust priority by this weight | -253..253 |
| `fall` | `Integer`       | `nil` | Required number of successes for OK transition  | |
| `rise` | `Integer`       | | Required number of successes for KO transition  | |
| `user` | `String`       | | User/group names to run script under, group default to group of user  | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, '00_keepalived_vrrp_script__#{name}__.conf')` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `vrrp_script.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_vrrp_script 'chk_haproxy' do
  script '/usr/local/bin/chk-haproxy.sh'
  timeout 10
  fall 20
  rise 30
  user 'scriptUser'
  notifies :restart, 'service[keepalived]', :delayed
end
```

```ruby
keepalived_vrrp_script 'mongo-active' do
  script '/usr/local/bin/chk-mongod.sh'
  interval 2
  weight 50
  notifies :restart, 'service[keepalived]', :delayed
end
```
