# keepalived_vrrp_instance

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_vrrp_instance` resource can be used to manage configuration within the `vrrp_instance` section of keepalived.conf.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name        | Type        |  Default | Description | Allowed Values |
------------- | ----------- | -------- | ----------- | -------------- |
| `virtual_router_id` | `Integer` | `nil` | (required) used to differentiate multiple instances of vrrpd | `0` to `255` |
| `master` | `true`, `false` | `false` | Initial state, MASTER or BACKUP | |
| `interface` | `String` | `nil` | interface for inside_network, bound by vrrp | |
| `use_vmac` | `String` | `nil` | Use VRRP Virtual MAC | |
| `vmac_xmit_base` | `true`, `false` | `nil` | Send/Recv VRRP messages from base interface instead of vmac interface | |
| `dont_track_primary` | `true`, `false` | `nil` | Ignore VRRP interface faults | |
| `track_interface` | `String` | `nil` | See ManPage | |
| `mcast_src_ip` | `String` | `nil` | See ManPage | |
| `unicast_src_ip` | `String` | `nil` | See ManPage | |
| `unicast_peer` | `Array` | `nil` | See ManPage | |
| `garp_master_delay` | `Integer` | `nil` | delay for second set of gratuitous ARPs after transition to MASTER. | |
| `garp_master_repeat` | `Integer` | `nil` | number of gratuitous ARP messages to send at a time after transition to MASTER | |
| `garp_master_refresh` | `Integer` | `nil` | minimum time interval for refreshing gratuitous ARPs while MASTER | |
| `garp_master_refresh_repeat` | `Integer` | `nil` | number of gratuitous ARP messages to send at a time while MASTER | |
| `priority` | `Integer` | `100` | for electing MASTER, highest priority wins | `0` up to `255` |
| `advert_int` | `Integer` | `nil` | VRRP Advert interval in seconds | |
| `authentication` | `Hash` | `nil` | See Manpage | `:auth_type`,`:auth_pass` Note: Symbols |
| `virtual_ipaddress` | `Array` | `nil` | addresses add or del on change to MASTER, to BACKUP | |
| `virtual_ipaddress_excluded` | `Array` | `nil` | See ManPage | |
| `virtual_routes` | `Array` | `nil` | routes add or del when changing to MASTER, to BACKUP | |
| `virtual_rules` | `Array` | `nil` | rules add or del when changing to MASTER, to BACKUP | |
| `track_script` | `Array` | `nil` | add a tracking script to the sync group | |
| `nopreempt` | `true`,`false` | `nil` | See ManPage | |
| `preempt_delay` | `Integer` | `nil` | Seconds after startup or seeing a lower priority master until preemption | `0` to `1000`|
| `strict_mode` | `true`,`false` | `nil` | Enforce strict VRRP protocol compliance | |
| `version` | `Integer` | `nil` | VRRP version to run on interface | `2`,`3` |
| `native_ipv6` | `true`,`false` | `nil` | force instance to use IPv6 | |
| `notify_stop` | `String` | `nil` | executed when stopping vrrp | |
| `notify_master` | `String` | `nil` | Script to run for notifications when transitioning to state of master | |
| `notify_backup` | `String` | `nil` | Script to run for notifications when transitioning to state of backup | |
| `notify_fault` | `String` | `nil` | Script to run for notifications when transitioning to state of fault | |
| `notify` | `String` | `nil` | Script to run for notifications when any transition of state happens | |
| `smtp_alert` | `true, false` | `nil` | Send email notification during state transition  | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, "keepalived_vrrp_instance__#{name}__.conf")` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `vrrp_instance.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_vrrp_instance 'inside_network' do
  master true
  interface node['network']['default_interface']
  virtual_router_id 51
  priority 101
  authentication auth_type: 'PASS', auth_pass: 'secret1'
  virtual_ipaddress %w( 192.168.1.1 )
  notify '/usr/local/bin/keepalived-notify.sh'
  smtp_alert true
  notifies :restart, 'service[keepalived]', :delayed
end
```
