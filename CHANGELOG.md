# keepalived Cookbook CHANGELOG

This file is used to list changes made in each version of the keepalived cookbook.

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

### Enhancements

- extended platform testing

## v2.0.0 (2016-04-25)

### Breaking Changes

- attribute-driven configuration is no longer supported
- remove net.ipv4.ip_nonlocal_bind sysctl management

### Enhancements

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

- **[COOK-3017](https://tickets.chef.io/browse/COOK-3017)** - Add support for `vrrp_sync_groups`

## v1.0.4

### Improvement

- [COOK-2919]: Status option not available

## v1.0.2

- [COOK-1965] - fixes template subscribes and readme typos

## v1.0.0

- [COOK-1656] - Make keepalived configurable. Add some tests.

## v0.7.1

- Initial public release.
