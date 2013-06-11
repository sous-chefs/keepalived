#
# Cookbook Name:: keepalived_test
# Recipe:: virtual_server_provider_create
#
# Copyright 2012, Rackspace US, Inc.
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

keepalived_virtual_server "myserver" do
  vs_listen_ip "127.0.0.1"
  vs_listen_port "8080"
  delay_loop 10
  lb_algo "rr"
  lb_kind "nat"
  vs_protocol "tcp"
  real_servers [
    { "ip" =>  "10.10.10.10", "port" => 8000 },
    { "ip" =>  "10.10.10.11", "port" => 8101 }
  ]
end
