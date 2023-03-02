# keepalived_vrrp_sync_group

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_vrrp_sync_group` resource can be used to configure VRRP Sync Groups (groups of resources that fail over together).

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `notify_master` | `String`       | `nil` | Script to run for notifications when transitioning to state of master | |
| `notify_backup` | `String`       | `nil` | Script to run for notifications when transitioning to state of backup | |
| `notify_fault` | `String`       | `nil` | Script to run for notifications when transitioning to state of fault | |
| `notify` | `String`       | `nil` | Script to run for notifications when any transition of state happens | |
| `smtp_alert` | `true, false`       | `nil` | Send email notification during state transition  | |
| `group` | `Array`       | | (Required) name of the vrrp_instance  | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, 'keepalived_vrrp_sync_group__#{name}__.conf')` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `vrrp_sync_group.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_vrrp_sync_group 'myGroup' do
  group %w(internal_systems external_clients)
  notify_master '/path/to_master.sh'
  notify_backup '/path/to_backup.sh'
  notify_fault  '/path/fault.sh'
  notify        '/path/notify.sh'
  notifies :restart, 'service[keepalived]', :delayed
end
```
