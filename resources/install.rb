unified_mode true

property :package_name, String, default: 'keepalived'
property :root_path,    String, default: '/etc/keepalived'
property :config_path,  String, default: lazy { "#{root_path}/conf.d" }
property :server_path,  String, default: lazy { "#{root_path}/servers.d" }
property :health_path,  String, default: lazy { "#{root_path}/checks.d" }
property :defaults_path, String, default: lazy {
  value_for_platform_family(
        debian: '/etc/default/keepalived',
        default: '/etc/sysconfig/keepalived'
      )
}
action :install do
  package new_resource.package_name

  [
    new_resource.config_path,
    new_resource.server_path,
    new_resource.health_path,
  ].each do |include_path|
    directory include_path do
      owner 'root'
      group 'root'
      mode '0755'
    end
  end

  # Include resource-generated configs
  file 'keepalived.conf' do
    path "#{new_resource.root_path}/keepalived.conf"
    content "include #{new_resource.config_path}/*.conf\n"
    owner 'root'
    group 'root'
    mode '0640'
  end

  # Create a dummy config file in the resource-generated configs directory
  file ::File.join(new_resource.config_path, 'empty.conf') do
    content '# Some versions of Keepalived won\'t start when include dir is empty'
    owner 'root'
    group 'root'
    mode '0640'
  end
end

action :remove do
  package new_resource.package_name do
    action :remove
  end

  [
    new_resource.config_path,
    new_resource.server_path,
    new_resource.health_path,
  ].each do |include_path|
    directory include_path do
      action :delete
    end
  end
end
