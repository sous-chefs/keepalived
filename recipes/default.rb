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

package "keepalived"

case node["platform_family"]
when "debian"
  if node['keepalived']['shared_address']
    file '/etc/sysctl.d/60-ip-nonlocal-bind.conf' do
      mode 0644
      content "net.ipv4.ip_nonlocal_bind=1\n"
    end

    service 'procps' do
      action :start
    end
  end
when "rhel"
  if node['keepalived']['shared_address']
    execute 'sysctl' do
      # http://serverfault.com/questions/477718/sysctl-p-etc-sysctl-conf-returns-error
      command '/sbin/sysctl -e -p /etc/sysctl.conf'
        action :nothing
    end

    bash 'add ip_nonlocal_bind settings' do
      user 'root'
      code <<-EOF
        echo '' >> /etc/sysctl.conf
        echo '# net.ipv4.ip_nonlocal_bind added by Chef.' >> /etc/sysctl.conf
        echo 'net.ipv4.ip_nonlocal_bind=1' >> /etc/sysctl.conf
      EOF
      notifies :run, 'execute[sysctl]', :immediately
      not_if "egrep '^net.ipv4.ip_nonlocal_bind=' /etc/sysctl.conf"
    end
  end
end

template "keepalived.conf" do
  path "/etc/keepalived/keepalived.conf"
  source "keepalived.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "keepalived" do
  supports :restart => true
  action [:enable, :start]
  subscribes :restart, "template[keepalived.conf]"
end
