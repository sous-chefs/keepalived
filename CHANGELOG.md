# CHANGELOG

This file is used to list changes made in each version of the keepalived cookbook.

## Unreleased

- Fix markdown

## 6.0.15 - *2024-02-01*

## 6.0.14 - *2024-02-01*

## 6.0.13 - *2024-01-31*

## 6.0.12 - *2023-09-28*

## 6.0.11 - *2023-09-28*

## 6.0.10 - *2023-07-10*

## 6.0.9 - *2023-06-08*

Standardise files with files in sous-chefs/repo-management

## 6.0.8 - *2023-05-17*

## 6.0.7 - *2023-05-03*

## 6.0.6 - *2023-04-01*

## 6.0.5 - *2023-03-02*

## 6.0.4 - *2023-02-27*

## 6.0.3 - *2023-02-14*

## 6.0.2 - *2023-02-14*

- Remove delivery folder

## 6.0.1 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 6.0.0 - *2021-07-03*

- Enable unified_mode for all resources
  - This bumps the required Chef version to at least 15.3
- Speed up spec tests by caching Chef run

## 5.2.1 - *2021-06-01*

- Standardise files with files in sous-chefs/repo-management

## 5.2.0 - *2020-11-25*

- Added support for LVS/IPVS scheduler to `keepalived_virtual_server` `lvs_sched` property:
  - `mh` "maglev hashing scheduling"
  - `fo` "weighted failover scheduling"
  - `ovf` "weighted overflow scheduling"
  - `lblcr` "locality-based least-connection with replication scheduling"
  - `sed` "shortest expected delay scheduling"
  - `nq` "never queue scheduling"

## 5.1.0

- Make the property `authentication` of `keepalived_vrrp_instance` optional

## 5.0.1

- Changed `value_for_platform_family` to be wrapped in lazy to fix issue with Chef 14

## 5.0.0

- Removed all attributes
- Removed all recipes
- Added resource called `keepalived_install`
- Changed service behaviour, this must now be declared directly as a resource.
- All other resources need to notify the service to restart when changes `notifies :restart, 'service[keepalived]', :delayed`
- Resolved issue with check names prefixing all check file names `{name}` section with a `port-` in them, this was incorrect and has now been removed.

## 4.0.0

- Added testing for newer operating systems
  - amazonlinux-2
  - debian 10
  - ubuntu 18.04
- Removed testing for older operating systems
  - amazonlinux
  - centos 6
  - debian 8
  - ubuntu 14.04
  - ubuntu 16.04
- Removed unnecessary allowed_actions from the resource
- Migrated to github actions for CI testing
- Migrated global_defs from HWRP to a Custom Resource
  - Removed property `config_name`
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `path`
  - Removed property `exists`
  - Removed property `enable_snmp_keepalived`, no longer in keepalived man page
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, 'global_defs.conf')`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `global_defs.conf.erb`
  - Added property `extra_options`
- Migrated static_ipaddress from HWRP to a Custom Resource
  - Removed property `config_name`
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `path`
  - Removed property `exists`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, 'static_ipaddress.conf')`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `static_ipaddress.conf.erb`
- Migrated static_routes from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, 'static_routes.conf')`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `static_routes.conf.erb`
- Migrated vrrp_sync_group from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, 'keepalived_vrrp_sync_group__#{name}__.conf')`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `vrrp_sync_group.conf.erb`
- Migrated vrrp_script from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, '00_keepalived_vrrp_script__#{name}__.conf')`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `vrrp_script.conf.erb`
- Migrated real_server from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/servers.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, 'keepalived_real_server__#{ipaddress}-#{port}__.conf')`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `real_server.conf.erb`
- Migrated tcp_check from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_tcp_check__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `tcp_check.conf.erb`
  - Changed property `bindto` this is now `bind_to`
- Migrated http_get from HWRP to a Custom Resource
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
- Migrated ssl_get from HWRP to a Custom Resource
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
- Migrated smtp_check from HWRP to a Custom Resource
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
- Migrated misc_check from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/checks.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_misc_check__port-#{name.to_s.gsub(/\s+/, '-')}__.conf"`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `misc_check.conf.erb`
- Migrated virtual_server_group from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_virtual_server_group__#{name}__.conf"`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `virtual_server_group.conf.erb`
- Migrated virtual_server from HWRP to a Custom Resource
  - Removed property `config_name`, property `config_file` now will be the full name
  - Removed property `content`, this is now build up from the supplied properties
  - Removed property `exists`
  - Removed property `path`
  - Removed property `lb_algo`, this property is not documented in the manpage
  - Removed property `lb_kind`, this property is not documented in the manpage
  - Added property `config_directory`, defaulted to: `/etc/keepalived/conf.d`
  - Added property `config_file`, defaulted to: `::File.join(config_directory, "keepalived_virtual_server__#{name.to_s.gsub(/\s+/, '-')}__.conf"`
  - Added property `cookbook`, defaulted to: `keepalived`
  - Added property `source`, defaulted to `virtual_server.conf.erb`
- Migrated vrrp_instance from HWRP to a Custom Resource
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

- Items of note
  - Any calls to resources that look like this: `resources(keepalived_http_get: 'health_check_url').path` need to be migrated to use the `config_file` instead, `resources(keepalived_http_get: 'health_check_url').config_file`

## 3.1.1 (2018-01-10)

- Update README for vrrp_instance property name change
- Allow authentication hash to use strings for keys
- Update Test Kitchen platforms
- fix unicast_peer var type in readme
- Changes needed to converge on CentOS7 and Debian9

## 3.1.0 (2017-03-20)

- Replace keepalived_vrrp_instance 'state' property with boolean 'master' property to fix Chef 13 compat
- Use the standard Apache-2.0 license string in the metadata
- Switch from Rake to delivery local mode for testing

## 3.0.2 (2017-02-13)

- add user option for vrrp_script blocks
- update test suite

## 3.0.1 (2016-09-21)

- fix chef_version in metadata

## 3.0.0 (2016-09-16)

- Testing updates
- Require Chef 12.1

## v2.1.1 (2016-07-13)

- pass through sensitive attribute to underlying file resource

## v2.1.0 (2016-06-15)

### Bugfixes

- fix chefspec matchers
- bump order of virtual_router_id in vrrp_instance config
- extended platform testing

## v2.0.0 (2016-04-25)

### Breaking Changes

- attribute-driven configuration is no longer supported
- remove net.ipv4.ip_nonlocal_bind sysctl management
- separate recipe concerns from single recipe to install, configure, service
- overhaul cookbook to use resources instead of attributes
- add daemon cli args management

## v1.3.0 (2015-10-21)

- Added RHEL based distros as supported platforms
- Added requirements section to the readme to clarify what distros are supported and the requirement of Chef 11+
- Updated .gitignore file
- Added Test Kitchen config
- Added Chef standard Rubocop config
- Added Travis CI testing
- Added Berksfile
- Updated Gemfile with the latest development dependencies
- Updated contributing and testing docs
- Added maintainers.md and maintainers.toml files
- Added Travis and cookbook version badges to the readme
- Updated Opscode -> Chef Software
- Added a Rakefile for simplified testing
- Added a Chefignore file
- Resolved Rubocop warnings
- Added source_url and issues_url to the metadata
- Added basic convergence Chefspec test

## v1.2.0 (2014-02-25)

- [COOK-4299] Avoid setting attributes without precedence

## v1.1.0

### New Feature

- Add support for `vrrp_sync_groups`

## v1.0.4

### Improvement

- [COOK-2919]: Status option not available

## v1.0.2

- [COOK-1965] - fixes template subscribes and readme typos

## v1.0.0

- [COOK-1656] - Make keepalived configurable. Add some tests.

## v0.7.1

- Initial public release.
