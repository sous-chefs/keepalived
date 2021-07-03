unified_mode true

property :instance_name,              String, name_property: true

property :virtual_router_id,          Integer, required: true, equal_to: 0.upto(255).to_a
property :master,                     [true, false], default: false
property :interface,                  String
property :use_vmac,                   String
property :vmac_xmit_base,             [true, false]
property :dont_track_primary,         [true, false]
property :track_interface,            Array
property :mcast_src_ip,               String
property :unicast_src_ip,             String
property :unicast_peer,               Array
property :garp_master_delay,          Integer
property :garp_master_repeat,         Integer
property :garp_master_refresh,        Integer
property :garp_master_refresh_repeat, Integer
property :priority,                   Integer, equal_to: 0.upto(255).to_a, default: 100
property :advert_int,                 Integer
property :authentication,             Hash, callbacks: {
                                                        'has required configuration' => lambda do |spec|
                                                          [:auth_type, :auth_pass].all? { |c| spec.keys.map(&:to_sym).include?(c) }
                                                        end,
                                                        'has supported auth_type' => lambda do |spec|
                                                          (%w(PASS AH) & [spec[:auth_type], spec['auth_type']]).any?
                                                        end,
                                                      }
property :virtual_ipaddress,          Array
property :virtual_ipaddress_excluded, Array
property :virtual_routes,             Array
property :virtual_rules,              Array
property :track_script,               Array
property :nopreempt,                  [true, false]
property :preempt_delay,              Integer, equal_to: 0.upto(1_000).to_a
property :strict_mode,                [true, false]
property :version,                    Integer, equal_to: [2, 3]
property :native_ipv6,                [true, false]
property :notify_stop,                String
property :notify_master,              String
property :notify_backup,              String
property :notify_fault,               String
property :notify,                     String
property :smtp_alert,                 [true, false]
property :config_directory,           String, default: '/etc/keepalived/conf.d'
property :config_file,                String, default: lazy { ::File.join(config_directory, "keepalived_vrrp_instance__#{name}__.conf") }
property :cookbook,                   String, default: 'keepalived'
property :source,                     String, default: 'vrrp_instance.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      instance_name: new_resource.instance_name,
      notify_master: new_resource.notify_master,
      notify_backup: new_resource.notify_backup,
      notify_fault: new_resource.notify_fault,
      notify: new_resource.notify,
      smtp_alert: new_resource.smtp_alert,
      virtual_router_id: new_resource.virtual_router_id,
      master: new_resource.master,
      interface: new_resource.interface,
      use_vmac: new_resource.use_vmac,
      vmac_xmit_base: new_resource.vmac_xmit_base,
      dont_track_primary: new_resource.dont_track_primary,
      track_interface: new_resource.track_interface,
      mcast_src_ip: new_resource.mcast_src_ip,
      unicast_src_ip: new_resource.unicast_src_ip,
      unicast_peer: new_resource.unicast_peer,
      garp_master_delay: new_resource.garp_master_delay,
      garp_master_repeat: new_resource.garp_master_repeat,
      garp_master_refresh: new_resource.garp_master_refresh,
      garp_master_refresh_repeat: new_resource.garp_master_refresh_repeat,
      priority: new_resource.priority,
      advert_int: new_resource.advert_int,
      authentication: new_resource.authentication,
      virtual_ipaddress: new_resource.virtual_ipaddress,
      virtual_ipaddress_excluded: new_resource.virtual_ipaddress_excluded,
      virtual_routes: new_resource.virtual_routes,
      virtual_rules: new_resource.virtual_rules,
      track_script: new_resource.track_script,
      nopreempt: new_resource.nopreempt,
      preempt_delay: new_resource.preempt_delay,
      strict_mode: new_resource.strict_mode,
      version: new_resource.version,
      native_ipv6: new_resource.native_ipv6,
      notify_stop: new_resource.notify_stop
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
