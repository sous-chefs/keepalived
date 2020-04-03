property :addresses,        Array, required: true
property :config_directory, String, default: '/etc/keepalived/conf.d'
property :config_file,      String, default: lazy { ::File.join(config_directory, 'static_ipaddress.conf') }
property :cookbook,         String, default: 'keepalived'
property :source,           String, default: 'static_ipaddress.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      addresses: new_resource.addresses
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
