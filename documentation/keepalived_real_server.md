
# keepalived_real_server

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_real_server` resource can be used to configure real_server blocks within a `virtual_server`. They are managed as separate configuration files, and injected into the `virtual_server` block via `include` directives configured via the `real_servers` property of the `keepalived_virtual_server` resource.

A `keepalived_real_server` can be associated with a healthcheck via an `include` of a file containing a check sub-block using the `healthcheck` property. If using any of the health check resources provided by this cookbook, you can use the `config_file` method on the associated resource to automatically get the appropriate configuration path, as shown below.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name                  | Type          |  Default | Description | Allowed Values |
----------------------- | ------------- | -------- | ----------- | -------------- |
| `ipaddress`           | `String`      | `nil` | IP Address of the Server | |
| `port`                | `Integer`     | `nil` | Port of the Server | |
| `healthcheck`         | `String`      | `nil` | Includes a healthcheck file | |
| `weight`              | `Integer`     | `nil` | Script to run for notifications when any transition of state happens | |
| `inhibit_on_failure`  | `true, false` | `nil` | | |
| `notify_up`           | `String`      | `nil`| Script to execute when healthchecker considers the service as up | |
| `notify_down`         | `String`      | `nil`| Script to execute when healthchecker considers the service as down | |
| `config_directory`      | `String` | `/etc/keepalived/servers.d` | directory for the config file to reside in | |
| `config_file`         | `String` | `::File.join(config_directory, 'keepalived_real_server__#{ipaddress}-#{port}__.conf')` | full path to the config file | |
| `cookbook`            | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source`              | `String` | `real_server.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_real_server 'Secure Web Server' do
  ipaddress ipaddress
  port      port
  notify_up '/usr/local/bin/keepalived-notify-up.sh'
  notify_down '/usr/local/bin/keepalived-notify-down.sh'
  inhibit_on_failure true
  notifies :restart, 'service[keepalived]', :delayed
end
```

```ruby
keepalived_http_get 'health_check_url' do
  nb_get_retry 3
  url path: '/health_check', status_code: 200
  notifies :restart, 'service[keepalived]', :delayed
end

keepalived_real_server 'fe01' do
  ipaddress '192.168.1.1'
  port 80
  weight 5
  inhibit_on_failure true
  healthcheck resources(keepalived_http_get: 'health_check_url').config_file
  notifies :restart, 'service[keepalived]', :delayed
end
```
