provides :keepalived_server_group

property :vips,             Array, default: []
property :fwmarks,          Array, default: [], callbacks: {
                                                'are all integers' => ->(spec) { spec.all? { |i| i.is_a?(Integer) } },
                                              }
property :config_directory, String, default: '/etc/keepalived/conf.d'
# set name to 00_ to force early load-order so it's defined before vrrp_instance(s) which may reference it via track_script
property :config_file,      String, default: lazy { ::File.join(config_directory, "keepalived_virtual_server_group__#{name}__.conf") }
property :cookbook,         String, default: 'keepalived'
property :source,           String, default: 'virtual_server_group.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      virtual_server_group_name: new_resource.name,
      vips: new_resource.vips,
      fwmarks: new_resource.fwmarks
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
