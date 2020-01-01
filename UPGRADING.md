# Upgrading

******************* we need to write correct unit tests and some inspec tests to validate the output config file is correct

## 2.0.0

the `cookbook` and `source` properites on resources allow you to override the template file the resource will use with your own

### keepalived_global_defs

- Removed property `config_name`, path now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Removed property `enable_snmp_keepalived`, no longer in keepalived man page
- Added property `conf_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(conf_directory, 'global_defs.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `global_defs.conf.erb`

### keepalived_static_ipaddress

- Removed property `config_name`, path now will be the full name
- Removed property `content`, this is now build up from the supplied properties
- Removed property `exists`
- Added property `conf_directory`, defaulted to: `/etc/keepalived/conf.d`
- Added property `config_file`, defaulted to: `::File.join(conf_directory, 'static_ipaddress.conf')`
- Added property `cookbook`, defaulted to: `keepalived`
- Added property `source`, defaulted to `static_ipaddress.conf.erb`
