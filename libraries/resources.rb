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

require_relative 'keepalived'
require_relative 'helpers'

require 'chef/resource'

class ChefKeepalived
  class Resource
    class Config < Chef::Resource
      resource_name :keepalived_config

      allowed_actions :create, :delete
      default_action :create

      def self.option_properties(options)
        options.each_pair { |n, c| property n, c.merge(desired_state: false) }
      end

      property :exists, [TrueClass, FalseClass]
      property :content, String, default: lazy { to_conf }
      property :path, String, desired_state: false,
                              default: lazy { "#{Keepalived::CONFIG_PATH}/#{config_name}.conf" }

      private

      def config_name
        to_s.gsub(/(\[|\])/, '__').gsub(/\s+/, '-')
      end

      def to_conf
        raise NotImplementedError
      end
    end

    class GlobalDefs < Config
      resource_name :keepalived_global_defs
      identity_attr :config_name

      option_properties Keepalived::GlobalDefs::OPTIONS

      private

      def config_name
        :global_defs
      end

      def to_conf
        cfg = ["#{config_name} {"]
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::GlobalDefs::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class StaticIpAddress < Config
      resource_name :keepalived_static_ipaddress
      identity_attr :config_name

      property :addresses, kind_of: Array, required: true, desired_state: false

      private

      def config_name
        :static_ipaddress
      end

      def to_conf
        cfg = ["#{config_name} {"]
        cfg << addresses.join("\n\t")
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class StaticRoutes < Config
      resource_name :keepalived_static_routes
      identity_attr :config_name

      property :routes, kind_of: Array, required: true, desired_state: false

      private

      def config_name
        :static_routes
      end

      def to_conf
        cfg = ["#{config_name} {"]
        cfg << routes.join("\n\t")
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class VrrpSyncGroup < Config
      resource_name :keepalived_vrrp_sync_group

      option_properties Keepalived::VrrpSyncGroup::OPTIONS

      private

      def to_conf
        cfg = ["vrrp_sync_group #{name} {"]
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::VrrpSyncGroup::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class VrrpScript < Config
      resource_name :keepalived_vrrp_script

      option_properties Keepalived::VrrpScript::OPTIONS

      private

      # override name to force early load-order
      # so it's defined before vrrp_instance(s)
      # which may reference it via track_script
      def config_name
        "00_#{super}"
      end

      def to_conf
        cfg = ["vrrp_script #{name} {"]
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::VrrpScript::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class VrrpInstance < Config
      resource_name :keepalived_vrrp_instance

      option_properties Keepalived::VrrpInstance::OPTIONS

      private

      def to_conf
        cfg = ["vrrp_instance #{name} {"]
        cfg << "state #{master ? 'MASTER' : 'BACKUP'}"
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::VrrpInstance::OPTIONS.reject { |k, _| k == :master }
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class VirtualServerGroup < Config
      resource_name :keepalived_virtual_server_group

      property :vips, kind_of: Array, desired_state: false
      property :fwmarks, kind_of: Array, desired_state: false, callbacks: {
        'are all integers' => ->(spec) { spec.all? { |i| i.is_a?(Integer) } },
      }

      private

      def to_conf
        cfg = ["virtual_server_group #{name} {"]
        cfg << vips.join("\n\t") if vips
        cfg << fwmarks.map { |fwm| "fwmark #{fwm}" }.join("\n\t") if fwmarks
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class VirtualServer < Config
      resource_name :keepalived_virtual_server

      option_properties Keepalived::VirtualServer::OPTIONS

      property :real_servers, kind_of: Array, required: true,
                              desired_state: false

      private

      def to_conf
        cfg = ["virtual_server #{name} {"]
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::VirtualServer::OPTIONS
        )
        cfg << real_servers.map do |server|
          "include #{server}"
        end
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class RealServer < Config
      resource_name :keepalived_real_server

      option_properties Keepalived::RealServer::OPTIONS

      property :healthcheck, kind_of: String, desired_state: false
      property :ipaddress, kind_of: String, required: true, desired_state: false
      property :port, kind_of: Integer, required: true, desired_state: false,
                      equal_to: 1.upto(65_535)
      property :path, String, desired_state: false,
                              default: lazy { "#{Keepalived::SERVER_PATH}/#{config_name}.conf" }

      private

      def to_conf
        cfg = ["real_server #{ipaddress} #{port} {"]
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::RealServer::OPTIONS
        )
        cfg << "include #{healthcheck}" if healthcheck
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class TcpCheck < Config
      resource_name :keepalived_tcp_check

      option_properties Keepalived::TcpCheck::OPTIONS

      property :path, String, desired_state: false,
                              default: lazy { "#{Keepalived::HEALTH_PATH}/#{config_name}.conf" }

      private

      def to_conf
        cfg = ['TCP_CHECK {']
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::TcpCheck::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class HttpGet < TcpCheck
      resource_name :keepalived_http_get

      option_properties Keepalived::HttpGet::OPTIONS

      private

      def to_conf
        cfg = ['HTTP_GET {']
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::HttpGet::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class SslGet < TcpCheck
      resource_name :keepalived_ssl_get

      option_properties Keepalived::SslGet::OPTIONS

      private

      def to_conf
        cfg = ['SSL_GET {']
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::SslGet::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class SmtpCheck < TcpCheck
      resource_name :keepalived_smtp_check

      option_properties Keepalived::SmtpCheck::OPTIONS

      private

      def to_conf
        cfg = ['SMTP_CHECK {']
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::SmtpCheck::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end

    class MiscCheck < Config
      resource_name :keepalived_misc_check

      option_properties Keepalived::MiscCheck::OPTIONS

      property :path, String, desired_state: false,
                              default: lazy { "#{Keepalived::HEALTH_PATH}/#{config_name}.conf" }

      private

      def to_conf
        cfg = ['MISC_CHECK {']
        cfg << Keepalived::Helpers.conf_string(
          self, Keepalived::MiscCheck::OPTIONS
        )
        cfg << '}'
        cfg.join("\n\t")
      end
    end
  end
end
