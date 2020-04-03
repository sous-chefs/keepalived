name             'keepalived'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'Installs and configures keepalived'
source_url       'https://github.com/chef-cookbooks/keepalived'
issues_url       'https://github.com/chef-cookbooks/keepalived/issues'
chef_version     '>= 13'
version          '4.0.0'

%w(ubuntu debian redhat centos scientific oracle amazon).each do |os|
  supports os
end
