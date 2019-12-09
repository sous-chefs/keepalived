property :config_name,                      String, name_property: true
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
property :vrrp_check_unicast_src,           String
property :vrrp_strict,                      [TrueClass, FalseClass]
property :vrrp_priority,                    Integer, equal_to: -20.upto(19).to_a
property :checker_priority,                 Integer, equal_to: -20.upto(19).to_a
property :vrrp_no_swap,                     [TrueClass, FalseClass]
property :checker_no_swap,                  [TrueClass, FalseClass]
property :snmp_socket,                      String
property :enable_snmp_keepalived,           [TrueClass, FalseClass]
property :enable_snmp_checker,              [TrueClass, FalseClass]
property :enable_snmp_rfc,                  [TrueClass, FalseClass]
property :enable_snmp_rfcv2,                [TrueClass, FalseClass]
property :enable_snmp_rfcv3,                [TrueClass, FalseClass]
property :enable_traps,                     [TrueClass, FalseClass]
property :enable_script_security,           [TrueClass, FalseClass]
property :exists,                           [TrueClass, FalseClass]
property :content,                          String, default: lazy { to_conf }
property :path,                             String, default: lazy { "/etc/keepalived/conf.d/#{new_resource.config_name}.conf" }

action :create do
  template new_resource.path do
    source 'global_defs.erb'
    cookbook 'keepalived'
    variables(
      grafana: node.run_state['sous-chefs'][new_resource.instance_name]['config']
    )
    owner 'root'
    group 'root'
    mode '640'
    action :create
  end
end

############## We need to have an additional options array, there are just too many options:
### https://www.keepalived.org/manpage.html
# This will allow us to support everything going forward
