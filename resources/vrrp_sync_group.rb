property :notify_master,  String
property :notify_backup,  String
property :notify_fault,   String
property :notify,         String
property :smtp_alert,     [true, false]
property :group,          Array, required: true
property :conf_directory, String, default: '/etc/keepalived/conf.d'
property :config_file,    String, default: lazy { ::File.join(conf_directory, "keepalived_vrrp_sync_group__#{name}__.conf") }
property :cookbook,       String, default: 'keepalived'
property :source,         String, default: 'vrrp_sync_group.conf.erb'

action :create do
  template new_resource.config_file do
    source new_resource.source
    cookbook new_resource.cookbook
    variables(
      group_name: new_resource.name,
      smtp_alert: new_resource.smtp_alert,
      groups: new_resource.group,
      notify_master: new_resource.notify_master,
      notify_backup: new_resource.notify_backup,
      notify_fault: new_resource.notify_fault,
      notify: new_resource.notify
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
