#
# Cookbook Name:: keepalived
# Provider:: virtual_server
#

action :create do
  r = template "vs_#{new_resource.name}" do
    path "/etc/keepalived/conf.d/vs_#{new_resource.name}.conf"
    source "vs_generic.conf.erb"
    cookbook "keepalived"
    owner "root"
    group "root"
    mode "0644"
    variables(
      "vs_listen_ip" => new_resource.vs_listen_ip,
      "vs_listen_port" => new_resource.vs_listen_port,
      "delay_loop" => new_resource.delay_loop,
      "lb_algo" => new_resource.lb_algo,
      "lb_kind" => new_resource.lb_kind,
      "vs_protocol" => new_resource.vs_protocol,
      "real_servers" => new_resource.real_servers
    )
    notifies :run, "execute[reload-keepalived]", :immediately
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
