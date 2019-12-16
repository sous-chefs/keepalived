#
# This is intended to test the resources, not produce a sane configuration :D
#
apt_update 'update' if platform_family?('debian')

include_recipe 'keepalived::default'

execute 'sysctl -w net.ipv4.ip_nonlocal_bind=1'

global_defs_extra_options = {'foo' => 'bar', 'other' => [1,2,3] }

keepalived_global_defs 'global_defs' do
  notification_email %w( root@localhost me@example.com )
  notification_email_from 'keepalived@localhost'
  smtp_server '127.0.0.1'
  smtp_connect_timeout 30
  router_id 'my_router'
  vrrp_mcast_group4 '224.0.0.18'
  vrrp_mcast_group6 'ff02::12'
  enable_traps true
  enable_script_security true
  extra_options global_defs_extra_options
end

keepalived_static_ipaddress 'static_ipaddress' do
  addresses [
    '192.168.1.1/24 dev eth0 scope global',
  ]
end

keepalived_static_routes 'static_routes' do
  routes [
    '192.168.2.0/24 via 192.168.1.100 dev eth0',
  ]
end

keepalived_vrrp_sync_group 'VG_1' do
  group %w( inside_network outside_network )
  smtp_alert true
end

keepalived_vrrp_script 'chk_haproxy' do
  interval 2
  weight 50
  script '"/usr/bin/killall -0 haproxy"'
  user 'root'
end

keepalived_vrrp_instance 'inside_network' do
  master true
  dont_track_primary true
  virtual_router_id 1
  priority 50
  interface node['network']['default_interface']
  unicast_peer %w( 10.120.13.1 )
  track_script %w( chk_haproxy )
  authentication(
    auth_type: 'PASS',
    auth_pass: 'buttz'
  )
  virtual_ipaddress %w( 192.168.4.92 )
  sensitive true
end

keepalived_vrrp_instance 'outside_network' do
  master true
  dont_track_primary true
  virtual_router_id 2
  interface node['network']['default_interface']
  priority 50
  authentication(
    auth_type: 'PASS',
    auth_pass: 'buttz'
  )
  virtual_ipaddress %w( 192.168.3.1 )
end

keepalived_virtual_server_group 'http' do
  vips ['192.168.1.13 80', '192.168.1.14 80']
end

keepalived_tcp_check 'port-6379' do
  connect_port 6379
  connect_timeout 5
end

keepalived_http_get 'port-80' do
  connect_timeout 15
  url path: '/health_check', status_code: 301
end

keepalived_ssl_get 'port-443' do
  connect_timeout 20
  url path: '/health_check', status_code: 200
end

keepalived_smtp_check 'port-25' do
  connect_timeout 30
  helo_name 'smtp.example.com'
end

file '/usr/local/bin/keepalived-ping-check.sh' do
  content <<-EOS
    #!/usr/bin/sh
    ping -c 2 8.8.8.8
  EOS
  mode '755'
end

keepalived_misc_check 'ping-check' do
  misc_path '/usr/local/bin/keepalived-ping-check.sh'
end

%w( 192.168.1.13 192.168.1.14 ).each do |addr|
  keepalived_real_server "#{addr}-80" do
    ipaddress addr
    port 80
    weight 5
    inhibit_on_failure true
    healthcheck resources(keepalived_http_get: 'port-80').path
  end

  keepalived_real_server "#{addr}-443" do
    ipaddress addr
    port 443
    weight 5
    inhibit_on_failure true
    healthcheck resources(keepalived_ssl_get: 'port-443').path
  end
end

https_servers = %w( 192.168.1.13 192.168.1.14 ).map do |addr|
  resources(keepalived_real_server: "#{addr}-443").path
end

keepalived_virtual_server '192.168.1.5 443' do
  lb_algo 'rr'
  lb_kind 'NAT'
  virtualhost 'www.example.com'
  quorum 2
  real_servers https_servers
end

http_servers = %w( 192.168.1.13 192.168.1.14 ).map do |addr|
  resources(keepalived_real_server: "#{addr}-80").path
end

keepalived_virtual_server '192.168.1.5 80' do
  lb_algo 'rr'
  lb_kind 'NAT'
  virtualhost 'www.example.com'
  quorum 2
  real_servers http_servers
end
