# keepalived Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/keepalived.svg?branch=master)](http://travis-ci.org/chef-cookbooks/keepalived) [![Cookbook Version](https://img.shields.io/cookbook/v/keepalived.svg)](https://supermarket.chef.io/cookbooks/keepalived)

Installs keepalived and generates the configuration files, using resource-driven configuration.

## Requirements

### Platforms

- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle

### Chef

- Chef 12.1+

### Cookbooks

- none

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

### Global Defs

The `keepalived_global_defs` resource is a singleton resource, which can be used to manage configuration within the `global_defs` section of keepalived.conf.

Example:

```ruby
keepalived_global_defs 'global_defs' do
  notification_email %w( sys-admin@example.com net-admin@example.com )
  notification_email_from "keepalived@#{node.name}"
  router_id node.name
  enable_traps true
end
```

Supported properties:

Property                        | Type                  | Default
------------------------------- | --------------------- | -------
notification_email              | Array                 | nil
notification_email_from         | String                | nil
smtp_server                     | String                | nil
smtp_helo_name                  | String                | nil
smtp_connect_timeout            | Integer               | nil
router_id                       | String                | nil
vrrp_mcast_group4               | String                | nil
vrrp_mcast_group6               | String                | nil
vrrp_garp_master_delay          | Integer               | nil
vrrp_garp_master_repeat         | Integer               | nil
vrrp_garp_master_refresh        | Integer               | nil
vrrp_garp_master_refresh_repeat | Integer               | nil
vrrp_version                    | Integer (2 or 3)      | nil
vrrp_iptables                   | String                | nil
vrrp_check_unicast_src          | String                | nil
vrrp_strict                     | TrueClass, FalseClass | nil
vrrp_priority                   | Integer -20->20       | nil
checker_priority                | Integer -20->20       | nil
vrrp_no_swap                    | TrueClass, FalseClass | nil
checker_no_swap                 | TrueClass, FalseClass | nil
snmp_socket                     | String                | nil
enable_snmp_keepalived          | TrueClass, FalseClass | nil
enable_snmp_checker             | TrueClass, FalseClass | nil
enable_snmp_rfc                 | TrueClass, FalseClass | nil
enable_snmp_rfcv2               | TrueClass, FalseClass | nil
enable_snmp_rfcv3               | TrueClass, FalseClass | nil
enable_traps                    | TrueClass, FalseClass | nil

### Static IP Addresses

The `keepalived_static_ipaddress` resource is a singleton resource, which can be used to manage configuration within the `static_ipaddress` section of keepalived.conf

Example:

```ruby
keepalived_static_ipaddress 'static_ipaddress' do
  addresses [
    '192.168.1.2/24 dev eth0 scope global',
    '192.168.1.3/24 dev eth0 scope global'
  ]
end
```

Supported properties:

Property  | Type  | Default
--------- | ----- | -------
addresses | Array | nil

### Static Routes

The `keepalived_static_routes` resource is a singleton resource, which can be used to manage configuration within the `static_routes` section of keepalived.conf.

Example:

```ruby
keepalived_static_routes 'static_routes' do
  routes [
    '192.168.2.0/24 via 192.168.1.100 dev eth0',
    '192.168.3.0/24 via 192.168.1.100 dev eth0'
  ]
end
```

Supported properties:

Property | Type  | Default
-------- | ----- | -------
routes   | Array | nil

### VRRP Sync Groups

The `keepalived_vrrp_sync_group` resource can be used to configure VRRP Sync Groups (groups of resources that fail over together).

Example:

```ruby
keepalived_vrrp_sync_group 'VG_1' do
  group %w( inside_network outside_network )
  notify '/usr/local/bin/keepalived-notify.sh'
  smtp_alert true
end
```

Supported properties:

Property      | Type                 | Default
------------- | -------------------- | -------
group         | Array                | nil
notify_master | String               | nil
notify_backup | String               | nil
notify_fault  | String               | nil
notify        | String               | nil
smtp_alert    | TrueClass,FalseClass | nil

### VRRP Track Scripts

The `keepalived_vrrp_script` resource can be used to configure a track script via a `vrrp_script` configuration block.

Example:

```ruby
keepalived_vrrp_script 'chk_haproxy' do
  interval 2
  weight 50
  script '"/usr/bin/killall -0 haproxy"'
end
```

Supported properties:

Property | Type    | Default
-------- | ------- | -------
script   | String  | nil
interval | Integer | nil
timeout  | Integer | nil
weight   | Integer | nil
fall     | Integer | nil
rise     | Integer | nil

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

### Virtual Server Groups

The `keepalived_virtual_server_group` resource can be used to configure a virtual server group via a `virtual_server_group` configuration block.

Example:

```ruby
keepalived_virtual_server_group 'web_frontend' do
  vips [
    '192.168.1.1-20 80',
    '192.168.2.1-20 80'
  ]
end
```

Supported properties:

Property | Type              | Default
-------- | ----------------- | -------
vips     | Array of Strings  | nil
fwmarks  | Array of Integers | nil

### Virtual Servers

The `keepalived_virtual_server` resource can be used to configure a virtual server via `virtual_server` configuration blocks.

Along with the officially supported directives, this resource takes a list of include paths under the `real_servers` property, which can be used to load `real_server` sections, whether configured with the `keepalived_real_server` resource or not. If using the `keepalived_real_server` resource, you can use the `path` method on the real_server resource to auto-generate the `real_servers` array from your Chef run_context, as shown below.

Example:

```ruby
frontends = search(:node, 'role:frontend')

frontends.each do |fe|
  keepalived_real_server fe.name do
    ipaddress fe['ipaddress']
    port 80
    weight 5
  end
end

server_paths = frontends.map do |fe|
  resources(keepalived_real_server: fe.name).path
end

keepalived_virtual_server '192.168.1.5 80' do
  lb_algo 'rr'
  lb_kind 'NAT'
  virtualhost 'www.example.com'
  sorry_server '127.0.0.1 8080'
  real_servers server_paths.to_a
end
```

Supported properties:

Property                | Type                                     | Default
----------------------- | ---------------------------------------- | -------
ip_family               | String (inet or inet6)                   | nil
delay_loop              | Integer                                  | nil
lvs_sched               | String (one of rr,wrr,lc,wlc,lblc,sh,dh) | nil
lb_algo                 | String (one of rr,wrr,lc,wlc,lblc,sh,dh) | nil
ops                     | TrueClass,FalseClass                     | nil
lb_kind                 | String (one of NAT,DR,TUN)               | nil
lvs_method              | String (one of NAT,DR,TUN)               | nil
persistence_engine      | String                                   | nil
persistence_timeout     | Integer                                  | nil
persistence_granularity | String                                   | nil
protocol                | String (TCP,UDP,SCTP)                    | nil
ha_suspend              | TrueClass,FalseClass                     | nil
virtualhost             | String                                   | nil
alpha                   | TrueClass,FalseClass                     | nil
omega                   | TrueClass,FalseClass                     | nil
quorum                  | Integer                                  | nil
hysteresis              | Integer                                  | nil
quorum_up               | String                                   | nil
quorum_down             | String                                   | nil
sorry_server            | String                                   | nil
sorry_server_inhibit    | TrueClass,FalseClass                     | nil
real_servers            | required, Array of Strings               | nil

### Real Servers

The `keepalived_real_server` resource can be used to configure real_server blocks within a `virtual_server`. They are managed as separate configuration files, and injected into the `virtual_server` block via `include` directives configured via the `real_servers` property of the `keepalived_virtual_server` resource.

A `keepalived_real_server` can be associated with a healthcheck via an `include` of a file containing a check sub-block using the `healthcheck` property. If using any of the health check resources provided by this cookbook, you can use the `path` method on the associated resource to automatically get the appropriate configuration path, as shown below.

Example:

```ruby
keepalived_http_get 'health_check_url' do
  nb_get_retry 3
  url path: '/health_check', status_code: 200
end

keepalived_real_server 'fe01' do
  ipaddress '192.168.1.1'
  port 80
  weight 5
  inhibit_on_failure true
  healthcheck resources(keepalived_http_get: 'health_check_url').path
end
```

Supported properties:

Property           | Type                        | Default
------------------ | --------------------------- | -------
ipaddress          | String (required)           | nil
port               | Integer (required, 0-65535) | nil
healthcheck        | String                      | nil
weight             | Integer                     | nil
inhibit_on_failure | TrueClass,FalseClass        | nil
notify_up          | String                      | nil
notify_down        | String                      | nil

### Health Checks

This cookbook provides a set of resources for configuring healthchecker sub-blocks within real_server sub-blocks of a virtual_server definition.

If you're using the `keepalived_real_server` resource, healthcheckers can be loaded using the `healthcheck` property of the `keepalived_real_server` resource along with the `path` method of the healthcheck resource, as shown in the documentation for the `keepalived_real_server` resource.

#### HTTP_GET

The `keepalived_http_get` resource can be used to configure a `HTTP_GET` healthchecker.

Example:

```ruby
keepalived_http_get 'http_check' do
  warmup 5
  nb_get_retry 3
  delay_before_retry 5
  url path: '/health_check', status_code: 200
end
```

Supported properties:

Property           | Type                                                                 | Default
------------------ | -------------------------------------------------------------------- | -------
connect_ip         | String                                                               | nil
connect_port       | Integer (0-65535)                                                    | nil
bindto             | String                                                               | nil
bind_port          | Integer (0-65535)                                                    | nil
connect_timeout    | Integer                                                              | nil
fwmark             | Integer                                                              | nil
nb_get_retry       | Integer                                                              | nil
delay_before_retry | Integer                                                              | nil
warmup             | Integer                                                              | nil
url                | Hash, required, w/ keys of :path, :status_code, and optional :digest | nil

#### SSL_GET

The `keepalived_ssl_get` resource can be used to configure an `SSL_GET` healthchecker.

Example:

```ruby
keepalived_ssl_get 'https_check' do
  warmup 5
  nb_get_retry 3
  delay_before_retry 5
  url path: '/health_check', status_code: 200
end
```

Supported properties:

Property           | Type                                                                 | Default
------------------ | -------------------------------------------------------------------- | -------
connect_ip         | String                                                               | nil
connect_port       | Integer (0-65535)                                                    | nil
bindto             | String                                                               | nil
bind_port          | Integer (0-65535)                                                    | nil
connect_timeout    | Integer                                                              | nil
fwmark             | Integer                                                              | nil
nb_get_retry       | Integer                                                              | nil
delay_before_retry | Integer                                                              | nil
warmup             | Integer                                                              | nil
url                | Hash, required, w/ keys of :path, :status_code, and optional :digest | nil

#### TCP_CHECK

The `keepalived_tcp_check` resource can be used to configure a `TCP_CHECK` healthecker.

Example:

```ruby
keepalived_tcp_check 'redis' do
  connect_port 6379
  connect_timeout 30
end
```

Supported properties:

Property        | Type              | Default
--------------- | ----------------- | -------
connect_ip      | String            | nil
connect_port    | Integer (0-65535) | nil
bindto          | String            | nil
bind_port       | Integer (0-65535) | nil
connect_timeout | Integer           | nil
fwmark          | Integer           | nil

#### SMTP_CHECK

The `keepalived_smtp_check` resource can be used to configure a `SMTP_CHECK` healthchecker.

Example:

```ruby
keepalived_smtp_check 'postfix' do
  helo_name node.name
  host connect_timeout: 30
end
```

Supported properties:

Property           | Type                                                                                     | Default
------------------ | ---------------------------------------------------------------------------------------- | -------
connect_timeout    | Integer                                                                                  | nil
delay_before_retry | nil
helo_name          | String                                                                                   | nil
warmup             | Integer                                                                                  | nil
host               | Hash, keys of :connect_ip, :connect_port, :bindto, :bind_port, :connect_timeout, :fwmark | nil

#### MISC_CHECK

The `keepalived_misc_check` resource can be used to configure a `MISC_CHECK` healthchecker.

Example:

```ruby
keepalived_misc_check 'ping-check' do
  misc_path '"/usr/bin/ping -c 3"'
  misc_timeout 5
  warmup 5
end
```

Supported properties:

Property     | Type                  | Default
------------ | --------------------- | -------
misc_path    | String                | nil
misc_timeout | Integer               | nil
warmup       | Integer               | nil
misc_dynamic | TrueClass, FalseClass | nil

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2009-2016, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
