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
      default_action :create

      def self.option_properties(options)
        options.each_pair { |n, c| property n, c.merge(desired_state: false) }
      end

      property :exists, [true, false]
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

    # class TcpCheck < Config
    #   resource_name :keepalived_tcp_check

    #   option_properties Keepalived::TcpCheck::OPTIONS

    #   property :path, String, desired_state: false,
    #                           default: lazy { "#{Keepalived::HEALTH_PATH}/#{config_name}.conf" }

    #   private

    #   def to_conf
    #     cfg = ['TCP_CHECK {']
    #     cfg << Keepalived::Helpers.conf_string(
    #       self, Keepalived::TcpCheck::OPTIONS
    #     )
    #     cfg << '}'
    #     cfg.join("\n\t")
    #   end
    # end

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
