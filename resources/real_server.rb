provides :keepalived_real_server

property :ipaddress,          String, required: true
property :port,               Integer, required: true, equal_to: 1.upto(65_535)
property :healthcheck,        String
property :weight,             Integer
property :inhibit_on_failure, [true, false]
property :notify_up,          String
property :notify_down,        String
property :config_directory,   String, default: '/etc/keepalived/servers.d'
property :config_file,        String, default: lazy { ::File.join(config_directory, "keepalived_real_server__#{ipaddress}-#{port}__.conf") }
property :cookbook,           String, default: 'keepalived'
property :source,             String, default: 'real_server.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      ipaddress: new_resource.ipaddress,
      port: new_resource.port,
      healthcheck: new_resource.healthcheck,
      weight: new_resource.weight,
      inhibit_on_failure: new_resource.inhibit_on_failure,
      notify_up: new_resource.notify_up,
      notify_down: new_resource.notify_down
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
