name              'keepalived'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures keepalived'

version           '3.1.1'

%w(ubuntu debian redhat centos scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/keepalived'
issues_url 'https://github.com/chef-cookbooks/keepalived/issues'
chef_version '>= 12.1'
