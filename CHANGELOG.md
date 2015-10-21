keepalived Cookbook CHANGELOG
=============================
This file is used to list changes made in each version of the keepalived cookbook.

v1.3.0 (2015-10-21)
-------------------
* Added RHEL based distros as supported platforms
* Added requirements section to the readme to clarify what distros are supported and the requirement of Chef 11+
* Updated .gitignore file
* Added Test Kitchen config
* Added Chef standard Rubocop config
* Added Travis CI testing
* Added Berksfile
* Updated Gemfile with the latest development dependencies
* Updated contributing and testing docs
* Added maintainers.md and maintainers.toml files
* Added Travis and cookbook version badges to the readme
* Updated Opscode -> Chef Software
* Added a Rakefile for simplified testing
* Added a Chefignore file
* Resolved Rubocop warnings
* Added source_url and issues_url to the metadata
* Added basic convergence Chefspec test

v1.2.0 (2014-02-25)
-------------------
- [COOK-4299] Avoid setting attributes without precedence

v1.1.0
------
### New Feature
- **[COOK-3017](https://tickets.chef.io/browse/COOK-3017)** - Add support for `vrrp_sync_groups`

v1.0.4
------
### Improvement
- [COOK-2919]: Status option not available

v1.0.2
------
- [COOK-1965] - fixes template subscribes and readme typos

v1.0.0
------
- [COOK-1656] - Make keepalived configurable. Add some tests.

v0.7.1
------
- Initial public release.
