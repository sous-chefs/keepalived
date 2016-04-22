#
# Cookbook Name:: keepalived
# Recipe:: configure
#
# Copyright 2009-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Configure sysctl to permit binding to non-local addresses
if node['keepalived']['shared_address']
  file '/etc/sysctl.d/60-ip-nonlocal-bind.conf' do
    mode '0644'
    content "net.ipv4.ip_nonlocal_bind=1\n"
  end

  service 'procps' do
    action :start
  end
end

# Set up directories for resource-generated configs
[
  Keepalived::CONFIG_PATH,
  Keepalived::SERVER_PATH,
  Keepalived::HEALTH_PATH
].each do |include_path|
  directory include_path do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

args = node['keepalived']['daemon_args']

file 'keepalived-options' do
  case node['platform_family']
  when 'rhel', 'fedora'
    path '/etc/sysconfig/keepalived'
  else
    path '/etc/default/keepalived'
  end
  content "KEEPALIVED_OPTIONS='#{args.join(' ')}'"
  owner 'root'
  group 'root'
  mode '0640'
  not_if { args.empty? }
end

# Include resource-generated configs
file 'keepalived.conf' do
  path "#{Keepalived::ROOT_PATH}/keepalived.conf"
  content "include #{Keepalived::CONFIG_PATH}/*.conf\n"
  owner 'root'
  group 'root'
  mode '0640'
end
