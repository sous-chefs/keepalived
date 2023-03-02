# keepalived_service

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_service` resource can be used to manage the `keepalived` service

## Actions

- `:create`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `package_name` | `String`       | `keepalived` | The name of the service | |
| `root_path` | `String`       | `/etc/keepalived` | The root of the configuration | |
| `config_path` | `String`       | `#{root_path}/conf.d` | Path to keep other config on disk | |
| `server_path` | `String`       | `#{root_path}/servers.d` | Path to keep all servers on disk | |
| `health_path` | `String`       | `#{root_path}/checks.d` | Path to keep all checks on disk | |
| `defaults_path` | `String`       | See Resource. | Where the defaults should be stored.| |

## Examples

After the install you should setup the service as well to be automatically started.

```ruby
keepalived_install 'keepalived' do
end

service 'keepalived' do
  action [:enable, :start]
end
```
