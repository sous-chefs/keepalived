
action :create do
  r = template new_resource.name do
    path "/etc/keepalived/conf.d/script_#{new_resource.name}.conf"
    source "script_generic.conf.erb"
    cookbook "keepalived"
    owner "root"
    group "root"
    mode "0644"
    variables(
      "name" => new_resource.name,
      "script" => new_resource.script,
      "interval" => new_resource.interval,
      "weight" => new_resource.weight,
      "rise" => new_resource.rise,
      "fall" => new_resource.fall
    )
    notifies :restart, resources(:service => "keepalived"), :delayed
  end
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
