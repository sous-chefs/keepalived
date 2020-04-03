property :misc_path,      String
property :misc_timeout,   Integer
property :warmup,         Integer
property :misc_dynamic,   [true, false]
property :config_directory, String, default: '/etc/keepalived/checks.d'
property :config_file,    String, default: lazy { ::File.join(config_directory, "keepalived_misc_check__port-#{name.to_s.gsub(/\s+/, '-')}__.conf") }
property :cookbook,       String, default: 'keepalived'
property :source,         String, default: 'misc_check.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      misc_path: new_resource.misc_path,
      misc_timeout: new_resource.misc_timeout,
      warmup: new_resource.warmup,
      misc_dynamic: new_resource.misc_dynamic
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
