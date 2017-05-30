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

module Keepalived
  ROOT_PATH ||= '/etc/keepalived'.freeze
  CONFIG_PATH ||= "#{ROOT_PATH}/conf.d".freeze
  SERVER_PATH ||= "#{ROOT_PATH}/servers.d".freeze
  HEALTH_PATH ||= "#{ROOT_PATH}/checks.d".freeze
  RESOURCES ||= %w(
    config
    global_defs
    static_ipaddress
    static_routes
    vrrp_sync_group
    vrrp_script
    vrrp_instance
    virtual_server_group
    virtual_server
    real_server
    http_get
    ssl_get
    tcp_check
    smtp_check
    misc_check
  ).map { |r| "keepalived_#{r}".to_sym }.freeze

  module GlobalDefs
    OPTIONS ||= {
      notification_email: { kind_of: Array },
      notification_email_from: { kind_of: String },
      smtp_server: { kind_of: String },
      smtp_helo_name: { kind_of: String },
      smtp_connect_timeout: { kind_of: Integer },
      router_id: { kind_of: String },
      vrrp_mcast_group4: { kind_of: String },
      vrrp_mcast_group6: { kind_of: String },
      vrrp_garp_master_delay: { kind_of: Integer },
      vrrp_garp_master_repeat: { kind_of: Integer },
      vrrp_garp_master_refresh: { kind_of: Integer },
      vrrp_garp_master_refresh_repeat: { kind_of: Integer },
      vrrp_version: { kind_of: Integer, equal_to: [2, 3] },
      vrrp_iptables: { kind_of: String },
      vrrp_check_unicast_src: { kind_of: String },
      vrrp_strict: { kind_of: [TrueClass, FalseClass] },
      vrrp_priority: { kind_of: Integer, equal_to: -20.upto(19).to_a },
      checker_priority: { kind_of: Integer, equal_to: -20.upto(19).to_a },
      vrrp_no_swap: { kind_of: [TrueClass, FalseClass] },
      checker_no_swap: { kind_of: [TrueClass, FalseClass] },
      snmp_socket: { kind_of: String },
      enable_snmp_keepalived: { kind_of: [TrueClass, FalseClass] },
      enable_snmp_checker: { kind_of: [TrueClass, FalseClass] },
      enable_snmp_rfc: { kind_of: [TrueClass, FalseClass] },
      enable_snmp_rfcv2: { kind_of: [TrueClass, FalseClass] },
      enable_snmp_rfcv3: { kind_of: [TrueClass, FalseClass] },
      enable_traps: { kind_of: [TrueClass, FalseClass] },
    }.freeze
  end

  module Notify
    OPTIONS ||= {
      notify_master: { kind_of: String },
      notify_backup: { kind_of: String },
      notify_fault: { kind_of: String },
      notify: { kind_of: String },
      smtp_alert: { kind_of: [TrueClass, FalseClass] },
    }.freeze
  end

  module VrrpSyncGroup
    OPTIONS ||= Notify::OPTIONS.merge(
      group: { kind_of: Array, required: true }
    ).freeze
  end

  module VrrpScript
    OPTIONS ||= {
      script: { kind_of: String, required: true },
      interval: { kind_of: Integer },
      timeout: { kind_of: Integer },
      weight: { kind_of: Integer, equal_to: -254.upto(254).to_a },
      fall: { kind_of: Integer },
      rise: { kind_of: Integer },
      user: { kind_of: String },
    }.freeze
  end

  module VrrpInstance
    OPTIONS ||= Notify::OPTIONS.merge(
      virtual_router_id: {
        kind_of: Integer,
        required: true,
        equal_to: 0.upto(255).to_a,
      },
      master: { kind_of: [TrueClass, FalseClass], default: false },
      interface: { kind_of: String },
      use_vmac: { kind_of: String },
      vmac_xmit_base: { kind_of: [TrueClass, FalseClass] },
      dont_track_primary: { kind_of: [TrueClass, FalseClass] },
      track_interface: { kind_of: Array },
      mcast_src_ip: { kind_of: String },
      unicast_src_ip: { kind_of: String },
      unicast_peer: { kind_of: Array },
      lvs_sync_daemon_interface: { kind_of: String },
      garp_master_delay: { kind_of: Integer },
      garp_master_repeat: { kind_of: Integer },
      garp_master_refresh: { kind_of: Integer },
      garp_master_refresh_repeat: { kind_of: Integer },
      priority: { kind_of: Integer, equal_to: 0.upto(255).to_a, default: 100 },
      advert_int: { kind_of: Integer },
      authentication: {
        kind_of: Hash,
        required: true,
        callbacks: {
          'has required configuration' => lambda do |spec|
            [:auth_type, :auth_pass].all? { |c| spec.keys.map(&:to_sym).include?(c) }
          end,
          'has supported auth_type' => lambda do |spec|
            (%w(PASS AH) & [spec[:auth_type], spec['auth_type']]).any?
          end,
        },
      },
      virtual_ipaddress: { kind_of: Array },
      virtual_ipaddress_excluded: { kind_of: Array },
      virtual_routes: { kind_of: Array },
      virtual_rules: { kind_of: Array },
      track_script: { kind_of: Array },
      nopreempt: { kind_of: [TrueClass, FalseClass] },
      preempt_delay: { kind_of: Integer, equal_to: 0.upto(1_000) },
      strict_mode: {
        kind_of: String,
        equal_to: %w( on off true false yes no ),
      },
      version: { kind_of: Integer, equal_to: [2, 3] },
      native_ipv6: { kind_of: [TrueClass, FalseClass] },
      notify_stop: { kind_of: String },
      debug: { kind_of: [TrueClass, FalseClass] }
    ).freeze
  end

  module VirtualServer
    OPTIONS ||= {
      ip_family: { kind_of: String, equal_to: %w( inet inet6 ) },
      delay_loop: { kind_of: Integer },
      lvs_sched: { kind_of: String, equal_to: %w( rr wrr lc wlc lblc sh dh ) },
      lb_algo: { kind_of: String, equal_to: %w( rr wrr lc wlc lblc sh dh ) },
      ops: { kind_of: [TrueClass, FalseClass] },
      lvs_method: { kind_of: String, equal_to: %w( NAT DR TUN ) },
      lb_kind: { kind_of: String, equal_to: %w( NAT DR TUN ) },
      persistence_engine: { kind_of: String },
      persistence_timeout: { kind_of: Integer },
      persistence_granularity: { kind_of: String },
      protocol: { kind_of: String, equal_to: %w( TCP UDP SCTP ) },
      ha_suspend: { kind_of: [TrueClass, FalseClass] },
      virtualhost: { kind_of: String },
      alpha: { kind_of: [TrueClass, FalseClass] },
      omega: { kind_of: [TrueClass, FalseClass] },
      quorum: { kind_of: Integer },
      hysteresis: { kind_of: Integer },
      quorum_up: { kind_of: String },
      quorum_down: { kind_of: String },
      sorry_server: { kind_of: String },
      sorry_server_inhibit: { kind_of: [TrueClass, FalseClass] },
    }.freeze
  end

  module RealServer
    OPTIONS ||= {
      weight: { kind_of: Integer },
      inhibit_on_failure: { kind_of: [TrueClass, FalseClass] },
      notify_up: { kind_of: String },
      notify_down: { kind_of: String },
    }.freeze
  end

  module TcpCheck
    OPTIONS ||= {
      connect_ip: { kind_of: String },
      connect_port: {
        kind_of: Integer,
        equal_to: 1.upto(65_535),
      },
      bindto: { kind_of: String },
      bind_port: {
        kind_of: Integer,
        equal_to: 1.upto(65_535),
      },
      connect_timeout: { kind_of: Integer },
      fwmark: { kind_of: Integer },
      warmup: { kind_of: Integer },
    }.freeze
  end

  module HttpGet
    OPTIONS ||= TcpCheck::OPTIONS.merge(
      url: {
        kind_of: Hash,
        required: true,
        default: { path: '/', status_code: 200 },
        callbacks: {
          'has only valid keys' => lambda do |spec|
            spec.keys.all? { |s| [:path, :digest, :status_code].include?(s) }
          end,
          'has required keys' => lambda do |spec|
            spec.keys.include?(:path) && spec.keys.include?(:status_code)
          end,
        },
      },
      nb_get_retry: { kind_of: Integer },
      delay_before_retry: { kind_of: Integer }
    ).freeze
  end

  module SslGet
    OPTIONS ||= HttpGet::OPTIONS
  end

  module SmtpCheck
    OPTIONS ||= TcpCheck::OPTIONS.merge(
      host: {
        kind_of: Hash,
        callbacks: {
          'has only valid keys' => lambda do |spec|
            spec.keys.all? { |s| TcpCheck::OPTIONS.keys.include?(s) }
          end,
        },
      },
      delay_before_retry: { kind_of: Integer },
      helo_name: { kind_of: String },
      connect_timeout: { kind_of: Integer }
    ).freeze
  end

  module MiscCheck
    OPTIONS ||= {
      misc_path: { kind_of: String },
      misc_timeout: { kind_of: Integer },
      warmup: { kind_of: Integer },
      misc_dynamic: { kind_of: [TrueClass, FalseClass] },
    }.freeze
  end
end
