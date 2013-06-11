#
# Cookbook Name:: keepalived
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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

include_recipe "sysctl::default"
include_recipe "osops-utils::packages"

package "keepalived" do
  action :install
end

execute "reload-keepalived" do
  command "#{node['keepalived']['service_bin']} keepalived reload"
  action :nothing
end

directory "/etc/keepalived/conf.d" do
  action :create
  owner "root"
  group "root"
  mode "0775"
end

sysctl "net.ipv4.ip_nonlocal_bind" do
  value "1"
  only_if { node["keepalived"]["shared_address"] }
end

template "keepalived.conf" do
  path "/etc/keepalived/keepalived.conf"
  source "keepalived.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, "execute[reload-keepalived]", :immediately
end

node["keepalived"]["check_scripts"].each_pair do |name, script|
  keepalived_chkscript name do
    script script["script"]
    interval script["interval"]
    weight script["weight"]
    action :create
  end
end

node["keepalived"]["instances"].each_pair do |name, instance|
  keepalived_vrrp name do
    interface instance["interface"]
    virtual_router_id node["keepalived"]["instance_defaults"]["virtual_router_id"]
    nopreempt false
    priority node["keepalived"]["instance_defaults"]["priority"]
    virtual_ipaddress Array(instance["ip_addresses"])
    if instance["track_script"]
      track_script instance["track_script"]
    end
    if instance["auth_type"]
      auth_type instance["auth_type"]
      auth_pass instance["auth_pass"]
    end
    action :create
  end
end

service "keepalived" do
  supports :restart => true, :status => true
  action [:enable, :start]
end
