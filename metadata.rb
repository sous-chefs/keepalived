name              'keepalived'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Installs and configures keepalived'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.3.0'

recipe 'keepalived', 'Installs and configures keepalived'

%w(ubuntu debian redhat centos scientific oracle amazon).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/keepalived' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/keepalived/issues' if respond_to?(:issues_url)
