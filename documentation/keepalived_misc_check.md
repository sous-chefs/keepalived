
# keepalived_misc_check

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_misc_check` resource can be used to configure a `MISC_CHECK` health checker.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name                  | Type          |  Default | Description | Allowed Values |
----------------------- | ------------- | -------- | ----------- | -------------- |
| `misc_path`           | `String`      | `nil`    | External script or program | |
| `misc_timeout`        | `Integer`     | `nil`    | Optional Script execution timeout | |
| `misc_dynamic`        | `true`, `false`| `false`    | See Manpage. | |
| `warmup`              | `Integer`     | `nil`| Optional random delay to start the initial check for maximum N seconds | |
| `config_directory`      | `String`      | `/etc/keepalived/checks.d` | directory for the config file to reside in | |
| `config_file`         | `String`      | `::File.join(config_directory, "keepalived_misc_check__#{name.to_s.gsub(/\s+/, '-')}__.conf")` | full path to the config file | |
| `cookbook`            | `String`      | `keepalived` | Which cookbook to look in for the template | |
| `source`              | `String`      | `misc_check.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_misc_check 'mysql' do
  misc_path '/opt/checks/misc/mysql.sh'
  misc_timeout 5
  warmup 10
  notifies :restart, 'service[keepalived]', :delayed
end
```
