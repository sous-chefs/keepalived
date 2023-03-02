
# keepalived_smtp_check

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_smtp_check` resource can be used to configure a `SMTP_CHECK` health checker.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name                  | Type          |  Default | Description | Allowed Values |
----------------------- | ------------- | -------- | ----------- | -------------- |
| `helo_name`           | `String`      | `nil` | Optional string to use for the SMTP HELO request | |
| `delay_before_retry`  | `Integer`     | `nil` | Optional delay before retry after failure | |
| `connect_ip`          | `String`      | `nil` | Optional IP address to connect to | |
| `connect_port`        | `Integer`     | `nil` | Optional port to connect to | |
| `bind_to`             | `String`      | `nil` | Optional address to use to originate the connection | |
| `bind_port`           | `Integer`     | `nil` | Optional source port to originate the connection from | |
| `connect_timeout`     | `Integer`     | `nil` | Optional connection timeout in seconds | |
| `fwmark`              | `Integer`     | `nil`| Optional fwmark to mark all outgoing checker packets with | |
| `warmup`              | `Integer`     | `nil`| Optional random delay to start the initial check for maximum N seconds | |
| `config_directory`      | `String`      | `/etc/keepalived/checks.d` | directory for the config file to reside in | |
| `config_file`         | `String`      | `::File.join(config_directory, "keepalived_smtp_check__#{name.to_s.gsub(/\s+/, '-')}__.conf")` | full path to the config file | |
| `cookbook`            | `String`      | `keepalived` | Which cookbook to look in for the template | |
| `source`              | `String`      | `smtp_check.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_smtp_check 'smtp01' do
  helo_name 'sous-chefs.org'
  delay_before_retry 5
  connect_port 25
  connect_timeout 10
  notifies :restart, 'service[keepalived]', :delayed
end
```
