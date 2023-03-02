
# keepalived_ssl_get

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_ssl_get` resource can be used to configure a `SSL_GET` health checker.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name                  | Type          |  Default | Description | Allowed Values |
----------------------- | ------------- | -------- | ----------- | -------------- |
| `url`                 | `Hash`        | `{ path: /, status_code: 200 }`| Optional URL to test | `:path`, `:status_code`, `digest`, note all are symbols
| `delay_before_retry`  | `Integer`     | `nil` | Optional delay before retry after failure | |
| `connect_ip`          | `String`      | `nil` | Optional IP address to connect to | |
| `connect_port`        | `Integer`     | `nil` | Optional port to connect to | |
| `bind_to`             | `String`      | `nil` | Optional address to use to originate the connection | |
| `bind_port`           | `Integer`     | `nil` | Optional source port to originate the connection from | |
| `connect_timeout`     | `Integer`     | `nil` | Optional connection timeout in seconds | |
| `fwmark`              | `Integer`     | `nil`| Optional fwmark to mark all outgoing checker packets with | |
| `warmup`              | `Integer`     | `nil`| Optional random delay to start the initial check for maximum N seconds | |
| `config_directory`      | `String`      | `/etc/keepalived/checks.d` | directory for the config file to reside in | |
| `config_file`         | `String`      | `::File.join(config_directory, "keepalived_ssl_get__#{name.to_s.gsub(/\s+/, '-')}__.conf")` | full path to the config file | |
| `cookbook`            | `String`      | `keepalived` | Which cookbook to look in for the template | |
| `source`              | `String`      | `ssl_get.conf.erb` | Name of the template to render | |

## Examples

```ruby
url_settings = { path: '/flask', digest: '123', status_code: 201 }

keepalived_ssl_get 'redis' do
  connect_port 6379
  connect_timeout 30
  delay_before_retry 5
  url url_settings
  notifies :restart, 'service[keepalived]', :delayed
end
```
