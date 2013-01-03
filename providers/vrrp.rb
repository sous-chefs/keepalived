
action :create do
  # This is dirty.. needs to be redone
  params = Hash.new()
  params['interface'] = new_resource.interface
  params['virtual_router_id'] = new_resource.virtual_router_id
  params['state'] = new_resource.state
  params['noprempt'] = new_resource.noprempt
  params['priority'] = new_resource.priority
  params['virtual_ipaddress'] = new_resource.virtual_ipaddress
  params['advert_int'] = new_resource.advert_int if new_resource.advert_int
  params['auth_type'] = new_resource.auth_type if new_resource.auth_type
  params['auth_pass'] = new_resource.auth_pass
  params['track_script'] = new_resource.track_script if new_resource.track_script

  template "vrrp_#{new_resource.name.upcase}" do
    path "/etc/keepalived/conf.d/vrrp_#{new_resource.name.upcase}.conf"
    source "vrrp_generic.conf.erb"
    cookbook "keepalived"
    owner "root"
    group "root"
    mode "0644"
    variables(
      "name" => new_resource.name,
      "params" => params
    )
    notifies :restart, resources(:service => "keepalived"), :delayed
  end
  new_resource.updated_by_last_action(true)
end
