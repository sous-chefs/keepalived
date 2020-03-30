# keepalived Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/keepalived.svg)](https://supermarket.chef.io/cookbooks/keepalived)
[![CI State](https://github.com/sous-chefs/keepalived/workflows/ci/badge.svg)](https://github.com/sous-chefs/keepalived/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs keepalived and generates the configuration files, using resource-driven configuration.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle

### Chef

- Chef 13+

## Recommended Background Reading

- `man:keepalived(8)`
- `man:keepalived.conf(5)`
- [Keepalived Documentation](https://github.com/acassen/keepalived/tree/master/doc)

## Usage

### Recipes

- `keepalived::default`: loads the install, configure, and service recipes
- `keepalived::install`: installs the `keepalived` package
- `keepalived::configure`: configures `/etc/keepalived/keepalived.conf` for inclusion of `keepalived_*` resources
- `keepalived::service`: enables/starts the `keepalived` service, sets a restart subscription to `/etc/keepalived/keepalived.conf`.

### Attributes

- `default['keepalived']['package']`: specify package name to install (e.g. 'keepalived/trusty-backports').
- `default['keepalived']['daemon_args']`: array of args to override default daemon cli args with
- `default['keepalived']['daemon_args_env_var']`: name of env var used by init script to pass in the daemon cli arguments
- `default['keepalived']['defaults_path']`: path of file to write daemon cli arg env var to (e.g. "/etc/default/keepalived")

## Resource Usage

This cookbook provides a set of resources for managing keepalived via LWRPs. These resources rely on support for the `include` directive, supported since keepalived version `1.1.15`, released in Sept, 2007. Please confirm your vendor package supports this before attempting to use these resources.

### Generic Config

The `keepalived_config` resource is the base resource on which other resources are built. It's not generally intended for direct consumption, but can be used in a pinch to provide a custom configuration if needed via the content property.

Example:

```ruby
keepalived_config 'linkbeat_use_polling' do
  content "linkbeat_use_polling"
end
```

Supported properties:

Property | Type   | Default
-------- | ------ | --------
content  | String | #to_conf
path     | String | dynamically computed

### VRRP Instances

The `keepalived_vrrp_instance` resource can be used to configure a VRRP instance with keepalived via a `vrrp_instance` configuration block.

Example:

```ruby
keepalived_vrrp_instance 'inside_network' do
  master true
  interface node['network']['default_interface']
  virtual_router_id 51
  priority 101
  authentication auth_type: 'PASS', auth_pass: 'buttz'
  virtual_ipaddress %w( 192.168.1.1 )
  notify '/usr/local/bin/keepalived-notify.sh'
  smtp_alert true
end
```

Supported properties:

Property                   | Type                                            | Default
-------------------------- | ----------------------------------------------- | -------
notify_master              | String                                          | nil
notify_backup              | String                                          | nil
notify_fault               | String                                          | nil
notify                     | String                                          | nil
notify_stop                | String                                          | nil
smtp_alert                 | TrueClass,FalseClass                            | nil
master                     | TrueClass,FalseClass                            | false
interface                  | String                                          | nil
use_vmac                   | String                                          | nil
vmac_xmit_base             | TrueClass,FalseClass                            | nil
dont_track_primary         | TrueClass,FalseClass                            | nil
track_interface            | Array                                           | nil
mcast_src_ip               | String                                          | nil
unicast_src_ip             | String                                          | nil
unicast_peer               | Array                                           | nil
lvs_sync_daemon_interface  | String                                          | nil
garp_master_delay          | Integer                                         | nil
garp_master_repeat         | Integer                                         | nil
garp_master_refresh        | Integer                                         | nil
garp_master_refresh_repeat | Integer                                         | nil
virtual_router_id          | Integer (0-255)                                 | nil
priority                   | Integer (0-255)                                 | 100
advert_int                 | Integer                                         | nil
authentication             | Hash, required, keys of: :auth_type, :auth_pass | nil
virtual_ipaddress          | Array                                           | nil
virtual_ipaddress_excluded | Array                                           | nil
virtual_routes             | Array                                           | nil
virtual_rules              | Array                                           | nil
track_script               | Array                                           | nil
nopreempt                  | TrueClass,FalseClass                            | nil
preempt_delay              | Integer (0-1000)                                | nil
strict_mode                | String                                          | nil
version                    | Integer                                         | nil
native_ipv6                | TrueClass, FalseClass                           | nil
debug                      | TrueClass, FalseClass                           | nil

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
