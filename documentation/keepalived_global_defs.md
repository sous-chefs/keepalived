# keepalived_global_defs

[back to resource list](https://github.com/sous-chefs/keepalived#resources)

The `keepalived_global_defs` resource can be used to manage configuration within the `global_defs` section of keepalived.conf.

More information available at <https://www.keepalived.org/manpage.html>

## Actions

- `:create`
- `:delete`

## Properties

| Name                            | Type        |  Default | Description | Allowed Values |
--------------------------------- | ----------- | -------- | ----------- | -------------- |
| `notification_email`              | `Array`       | `nil` | Set of email To: notify | |
| `notification_email_from`         | `String`      | `nil` | email from address that will be in the header | |
| `smtp_server`                     | `String`      | `nil` | Remote SMTP server used to send notification email | |
| `smtp_helo_name`                  | `String`      | `nil` | Name to use in HELO messages | |
| `smtp_connect_timeout`            | `Integer`     | `nil` | SMTP server connection timeout in seconds | |
| `router_id`                       | `String`      | `nil` | String identifying the machine | |
| `vrrp_mcast_group4`               | `String`      | `nil` | Multicast Group to use for IPv4 VRRP adverts | |
| `vrrp_mcast_group6`               | `String`      | `nil` | Multicast Group to use for IPv6 VRRP adverts | |
| `vrrp_garp_master_delay`          | `Integer`     | `nil` | delay for second set of gratuitous ARPs after transition to MASTER | |
| `vrrp_garp_master_repeat`         | `Integer`     | `nil` | number of gratuitous ARP messages to send at a time after transitioning to MASTER | |
| `vrrp_garp_master_refresh`        | `Integer`     | `nil` | minimum time interval for refreshing gratuitous ARPs while MASTER | |
| `vrrp_garp_master_refresh_repeat` | `Integer`     | `nil` | vrrp_garp_master_refresh_repeat | |
| `vrrp_version`                    | `Integer`     | `nil` | Set the default VRRP version to use | `2` or `3`|
| `vrrp_iptables`                   | `String`      | `nil` | Specify the iptables chain for v3 vrrp| |
| `vrrp_check_unicast_src`          | `String`      | `nil` | The following enables checking that when in unicast mode | |
| `vrrp_strict`                     | `True, False` | `nil` | Enforce strict VRRP protocol compliance | |
| `vrrp_priority`                   | `Integer`     | `nil` | Set the vrrp child process priority (Negative values increase priority) | between `-20` and `19` |
| `checker_priority`                | `Integer`     | `nil` | Set the checker child process priority | between `-20` and `19` |
| `vrrp_no_swap`                    | `True, False` | `nil` | Set the vrrp child process non swappable | |
| `checker_no_swap`                 | `True, False` | `nil` | Set the checker child process non swappable | |
| `snmp_socket`                     | `String`      | `nil` | Specify socket to use for connecting to SNMP master agent | |
| `enable_snmp_checker`             | `True, False` | `nil` | enable SNMP handling of checker element of KEEPALIVED MIB | |
| `enable_snmp_rfc`                 | `True, False` | `nil` | enable SNMP handling of RFC2787 and RFC6527 VRRP MIBs | |
| `enable_snmp_rfcv2`               | `True, False` | `nil` | enable SNMP handling of RFC2787 VRRP MIB | |
| `enable_snmp_rfcv3`               | `True, False` | `nil` | enable SNMP handling of RFC2787 VRRP MIB | |
| `enable_traps`                    | `True, False` | `nil` | enable SNMP traps | |
| `enable_script_security`          | `True, False` | `nil` | Don't run scripts configured to be run as root if any part of the path is writable by a non-root user | |
| `extra_options` | `Hash` | `nil` | A hash of additional options for the config file that are not yet exposed as properties | |
| `config_directory` | `String` | `/etc/keepalived/conf.d` | directory for the config file to reside in | |
| `config_file` | `String` | `::File.join(config_directory, 'global_defs.conf')` | full path to the config file | |
| `cookbook` | `String` | `keepalived` | Which cookbook to look in for the template | |
| `source` | `String` | `global_defs.conf.erb` | Name of the template to render | |

## Examples

```ruby
keepalived_global_defs 'global_defs' do
  notification_email %w( sys-admin@example.com net-admin@example.com )
  notification_email_from "keepalived@#{node['name']}"
  router_id node['name']
  enable_traps true
  notifies :restart, 'service[keepalived]', :delayed
end
```
