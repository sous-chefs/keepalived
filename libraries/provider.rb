#
# Cookbook:: keepalived
#
# Copyright:: 2016, Nathan Williams, <nath.e.will@gmail.com>
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

require 'chef/provider'
require 'chef/resource/file'

require_relative 'keepalived'

class ChefKeepalived
  class Provider
    class Config < Chef::Provider
      Keepalived::RESOURCES.each { |r| provides r.to_sym }

      def load_current_resource
        @current_resource =
          ChefKeepalived::Resource::Config.new(new_resource.name)

        current_resource.exists(::File.exist?(new_resource.path))

        if current_resource.exists
          current_resource.content(::File.read(new_resource.path).chomp)
        else
          current_resource.content('')
        end

        current_resource
      end

      def action_create
        converge_by("Create keepalived config: #{new_resource}") do
          manage_config_file(:create)
        end if !current_resource.exists || current_resource.content != new_resource.content
      end

      def action_delete
        converge_by("Delete keepalived config: #{new_resource}") do
          manage_config_file(:delete)
        end if current_resource.exists
      end

      private

      def manage_config_file(action = :nothing)
        Chef::Resource::File.new(new_resource.path, run_context).tap do |f|
          f.content "#{new_resource.content}\n"
          f.owner 'root'
          f.group 'root'
          f.mode '0640'
          f.sensitive new_resource.sensitive if defined?(:sensitive)
        end.run_action(action)
      end
    end
  end
end
