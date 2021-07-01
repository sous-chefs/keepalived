unified_mode true

property :script,           String, required: true
property :interval,         Integer
property :timeout,          Integer
property :weight,           Integer, equal_to: -254.upto(254).to_a
property :fall,             Integer
property :rise,             Integer
property :user,             String
property :config_directory, String, default: '/etc/keepalived/conf.d'
# set name to 00_ to force early load-order so it's defined before vrrp_instance(s) which may reference it via track_script
property :config_file,      String, default: lazy { ::File.join(config_directory, "00_keepalived_vrrp_script__#{name}__.conf") }
property :cookbook,         String, default: 'keepalived'
property :source,           String, default: 'vrrp_script.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      script_name: new_resource.name,
      script: new_resource.script,
      interval: new_resource.interval,
      timeout: new_resource.timeout,
      weight: new_resource.weight,
      fall: new_resource.fall,
      rise: new_resource.rise,
      user: new_resource.user
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
