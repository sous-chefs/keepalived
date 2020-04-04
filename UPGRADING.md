# Upgrading

## 5.0.0

The recipies have been removed and a resource called `keepalived_install` has been created.

The service must now be declared directly as a resource.

All other resources need to notify the service to restart when changes `notifies :restart, 'service[keepalived]', :delayed`

Resolved issue with check names prefixing all checks names with a port- in them, this was incorrect and has now been removed.

## 4.0.0

the `cookbook` and `source` properites on resources allow you to override the template file the resource will use with your own

### keepalived_global_defs

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Removed property `enable_snmp_keepalived`, no longer in keepalived man page
- Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, 'global_defs.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `global_defs.conf.erb`

### keepalived_static_ipaddress

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, 'static_ipaddress.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `static_ipaddress.conf.erb`

### keepalived_static_routes

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, 'static_ipaddress.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `static_ipaddress.conf.erb`

### keepalived_vrrp_sync_group

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, 'keepalived_vrrp_sync_group__#{name}__.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `vrrp_sync_group.conf.erb`

### keepalived_vrrp_script

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, '00_keepalived_vrrp_script__#{name}__.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `vrrp_script.conf.erb`

### keepalived_real_server

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/servers.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, 'keepalived_real_server__#{ipaddress}-#{port}__.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `real_server.conf.erb`

## keepalived_tcp_check

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_tcp_check__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `tcp_check.conf.erb`
- Changed property `bindto` this is now `bind_to`

## keepalived_http_get

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Removed property `nb_get_retry`, this is no longer in the manpage so it not supported
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_http_get__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `http_get.conf.erb`
- Changed property `bindto` this is now `bind_to`
- Changed property `url` to no longer be required, it has a default already

## keepalived_ssl_get

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Removed property `nb_get_retry`, this is no longer in the manpage so it not supported
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_ssl_get__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `ssl_get.conf.erb`
- Changed property `bindto` this is now `bind_to`
- Changed property `url` to no longer be required, it has a default already

## keepalived_smtp_check

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Removed property `host`
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_smtp_check__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `smtp_check.conf.erb`
- Changed property `bindto` this is now `bind_to`

## keepalived_misc_check

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_misc_check__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `misc_check.conf.erb`

## keepalived_virtual_server_group

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_virtual_server_group__#{name}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `virtual_server_group.conf.erb`

## keepalived_virtual_server

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Removed property `lb_algo`, this property is not documented in the manpage
- Removed property `lb_kind`, this property is not documented in the manpage
- Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_virtual_server__#{name.to_s.gsub(/\s+/, '-')}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `virtual_server.conf.erb`

## keepalived_vrrp_instance

- Removed property `config_name`, property `config_file` now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `path`
- Removed property `lvs_sync_daemon_interface`, it is not in the manpage
- Removed property `debug`, manpage states not implemented yet
- Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_vrrp_instance__#{name}__.conf"`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `vrrp_instance.conf.erb`
- Changed property `strict_mode` to a boolean, this was previously a String
