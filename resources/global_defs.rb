
property :notification_email,               Array
property :notification_email_from,          String
property :smtp_server,                      String
property :smtp_helo_name,                   String
property :smtp_connect_timeout,             Integer
property :router_id,                        String
property :vrrp_mcast_group4,                String
property :vrrp_mcast_group6,                String
property :vrrp_garp_master_delay,           Integer
property :vrrp_garp_master_repeat,          Integer
property :vrrp_garp_master_refresh,         Integer
property :vrrp_garp_master_refresh_repeat,  Integer
property :vrrp_version,                     Integer, equal_to: [2, 3]
property :vrrp_iptables,                    String
property :vrrp_check_unicast_src,           [true, false]
property :vrrp_strict,                      [true, false]
property :vrrp_priority,                    Integer, equal_to: -20.upto(19).to_a
property :checker_priority,                 Integer, equal_to: -20.upto(19).to_a
property :vrrp_no_swap,                     [true, false]
property :checker_no_swap,                  [true, false]
property :snmp_socket,                      String
property :enable_snmp_checker,              [true, false]
property :enable_snmp_rfc,                  [true, false]
property :enable_snmp_rfcv2,                [true, false]
property :enable_snmp_rfcv3,                [true, false]
property :enable_traps,                     [true, false]
property :enable_script_security,           [true, false]
property :extra_options,                    Hash
property :config_directory,                 String, default: '/etc/keepalived/conf.d'
property :config_file,                      String, default: lazy { ::File.join(config_directory, 'global_defs.conf') }
property :cookbook,                         String, default: 'keepalived'
property :source,                           String, default: 'global_defs.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      notification_email: new_resource.notification_email,
      notification_email_from: new_resource.notification_email_from,
      smtp_server: new_resource.smtp_server,
      smtp_helo_name: new_resource.smtp_helo_name,
      smtp_connect_timeout: new_resource.smtp_connect_timeout,
      router_id: new_resource.router_id,
      vrrp_mcast_group4: new_resource.vrrp_mcast_group4,
      vrrp_mcast_group6: new_resource.vrrp_mcast_group6,
      vrrp_garp_master_delay: new_resource.vrrp_garp_master_delay,
      vrrp_garp_master_repeat: new_resource.vrrp_garp_master_repeat,
      vrrp_garp_master_refresh: new_resource.vrrp_garp_master_refresh,
      vrrp_garp_master_refresh_repeat: new_resource.vrrp_garp_master_refresh_repeat,
      vrrp_version: new_resource.vrrp_version,
      vrrp_iptables: new_resource.vrrp_iptables,
      vrrp_check_unicast_src: new_resource.vrrp_check_unicast_src,
      vrrp_strict: new_resource.vrrp_strict,
      vrrp_priority: new_resource.vrrp_priority,
      checker_priority: new_resource.checker_priority,
      vrrp_no_swap: new_resource.vrrp_no_swap,
      checker_no_swap: new_resource.checker_no_swap,
      snmp_socket: new_resource.snmp_socket,
      enable_snmp_checker: new_resource.enable_snmp_checker,
      enable_snmp_rfc: new_resource.enable_snmp_rfc,
      enable_snmp_rfcv2: new_resource.enable_snmp_rfcv2,
      enable_snmp_rfcv3: new_resource.enable_snmp_rfcv3,
      enable_traps: new_resource.enable_traps,
      enable_script_security: new_resource.enable_script_security,
      extra_options: new_resource.extra_options
    )
    owner 'root'
    group 'root'
    mode '0640'
    action :create
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end
end
