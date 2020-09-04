provides :keepalived_virtual_server

property :ip_address,               String, name_property: true
property :real_servers,             Array, required: true
property :ip_family,                String, equal_to: %w( inet inet6 )
property :delay_loop,               Integer
property :lvs_sched,                String, equal_to: %w( rr wrr lc wlc lblc sh dh )
property :ops,                      [true, false]
property :lvs_method,               String, equal_to: %w( NAT DR TUN )
property :persistence_engine,       String
property :persistence_timeout,      Integer
property :persistence_granularity,  String
property :protocol,                 String, equal_to: %w( TCP UDP SCTP )
property :ha_suspend,               [true, false]
property :virtualhost,              String
property :alpha,                    [true, false]
property :omega,                    [true, false]
property :quorum,                   Integer
property :hysteresis,               Integer
property :quorum_up,                String
property :quorum_down,              String
property :sorry_server,             String
property :sorry_server_inhibit,     [true, false]
property :config_directory,         String, default: '/etc/keepalived/conf.d'
property :config_file,              String, default: lazy { ::File.join(config_directory, "keepalived_virtual_server__#{name.to_s.gsub(/\s+/, '-')}__.conf") }
property :cookbook,                 String, default: 'keepalived'
property :source,                   String, default: 'virtual_server.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      ip_address: new_resource.ip_address,
      real_servers: new_resource.real_servers,
      ip_family: new_resource.ip_family,
      delay_loop: new_resource.delay_loop,
      lvs_sched: new_resource.lvs_sched,
      ops: new_resource.ops,
      lvs_method: new_resource.lvs_method,
      persistence_engine: new_resource.persistence_engine,
      persistence_timeout: new_resource.persistence_timeout,
      persistence_granularity: new_resource.persistence_granularity,
      protocol: new_resource.protocol,
      ha_suspend: new_resource.ha_suspend,
      virtualhost: new_resource.virtualhost,
      alpha: new_resource.alpha,
      omega: new_resource.omega,
      quorum: new_resource.quorum,
      hysteresis: new_resource.hysteresis,
      quorum_up: new_resource.quorum_up,
      quorum_down: new_resource.quorum_down,
      sorry_server: new_resource.sorry_server,
      sorry_server_inhibit: new_resource.sorry_server_inhibit
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
