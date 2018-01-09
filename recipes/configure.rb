#
# Cookbook:: keepalived
# Recipe:: configure
#
# Copyright:: 2009-2016, Chef Software, Inc.
# Copyright:: 2018, Workday, Inc.
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

# Set up directories for resource-generated configs
[
  Keepalived::CONFIG_PATH,
  Keepalived::SERVER_PATH,
  Keepalived::HEALTH_PATH,
].each do |include_path|
  directory include_path do
    owner 'root'
    group 'root'
    mode '0755'
  end
end

# Set up daemon argument overrides
args = node['keepalived']['daemon_args']
env_var = node['keepalived']['daemon_args_env_var']

file 'keepalived-options' do
  path node['keepalived']['defaults_path']
  content "#{env_var}='#{args.join(' ')}'"
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

# Create a dummy config file in the resource-generated configs directory
file File.join(Keepalived::CONFIG_PATH, 'empty.conf') do
  content '# Some versions of Keepalived won\'t start when include dir is empty'
  owner 'root'
  group 'root'
  mode '0640'
end
