name              'keepalived'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache-2.0'
description       'Installs and configures keepalived'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '3.1.1'

recipe 'keepalived::default', 'Install, configure, and run keepalived'
recipe 'keepalived::install', 'Install keepalived package'
recipe 'keepalived::configure', 'Configure keepalived via attributes'
recipe 'keepalived::service', 'Enable, start the keepalived service'

%w(ubuntu debian redhat centos scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/keepalived'
issues_url 'https://github.com/chef-cookbooks/keepalived/issues'
chef_version '>= 12.1' if respond_to?(:chef_version)
