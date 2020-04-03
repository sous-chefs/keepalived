control 'package' do
  impact 1
  desc 'Keepalived package is installed'

  describe package('keepalived') do
    it { should be_installed }
  end
end

control 'service' do
  impact 1
  desc 'Keepalived service is running'

  describe service('keepalived') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end


control 'is configured' do
  # Configs
  describe file('/etc/keepalived/keepalived.conf') do
    its(:content) { should match(%r{include /etc/keepalived/conf.d/\*\.conf}) }
  end

  describe file('/etc/keepalived/conf.d/global_defs.conf') do
    its(:content) { should match(/router_id my_router/) }
  end

  describe file('/etc/keepalived/conf.d/global_defs.conf') do
    its(:content) { should match(/enable_script_security/) }
  end

  describe file('/etc/keepalived/conf.d/static_ipaddress.conf') do
    its(:content) { should match(/192.168.1.1/) }
  end

  describe file('/etc/keepalived/conf.d/static_routes.conf') do
    its(:content) { should match(/192.168.2.0/) }
  end

  describe file('/etc/keepalived/conf.d/keepalived_virtual_server_group__http__.conf') do
    its(:content) { should match(/192.168.1.13 80/) }
  end

  describe file('/etc/keepalived/conf.d/keepalived_virtual_server__192.168.1.5-80__.conf') do
    its(:content) { should match(/virtualhost www.example.com/) }
  end

  describe file('/etc/keepalived/conf.d/keepalived_virtual_server__192.168.1.5-443__.conf') do
    its(:content) { should match(/virtualhost www.example.com/) }
  end

  describe file('/etc/keepalived/conf.d/00_keepalived_vrrp_script__chk_haproxy__.conf') do
    its(:content) { should match(/killall/) }
    its(:content) { should match(/user root/) }
  end

  describe file('/etc/keepalived/conf.d/keepalived_vrrp_instance__inside_network__.conf') do
    its(:content) { should match(/virtual_router_id 1/) }
    its(:content) { should match(/state MASTER/) }
  end

  describe file('/etc/keepalived/conf.d/keepalived_vrrp_instance__outside_network__.conf') do
    its(:content) { should match(/virtual_router_id 2/) }
    its(:content) { should match(/state MASTER/) }
  end

  describe file('/etc/keepalived/conf.d/keepalived_vrrp_sync_group__VG_1__.conf') do
    its(:content) { should match(/smtp_alert/) }
  end

  # Servers
  describe file('/etc/keepalived/servers.d/keepalived_real_server__192.168.1.13-443__.conf') do
    its(:content) { should match(/real_server 192.168.1.13 443/) }
  end

  describe file('/etc/keepalived/servers.d/keepalived_real_server__192.168.1.13-80__.conf') do
    its(:content) { should match(/real_server 192.168.1.13 80/) }
  end

  describe file('/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf') do
    its(:content) { should match(/real_server 192.168.1.14 443/) }
  end

  describe file('/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-80__.conf') do
    its(:content) { should match(/real_server 192.168.1.14 80/) }
  end

  # Checks
  describe file('/etc/keepalived/checks.d/keepalived_http_get__port-80__.conf') do
    its(:content) { should match(/HTTP_GET/) }
  end

  describe file('/etc/keepalived/checks.d/keepalived_misc_check__ping-check__.conf') do
    its(:content) { should match(/MISC_CHECK/) }
  end

  describe file('/etc/keepalived/checks.d/keepalived_smtp_check__port-25__.conf') do
    its(:content) { should match(/SMTP_CHECK/) }
  end

  describe file('/etc/keepalived/checks.d/keepalived_ssl_get__port-443__.conf') do
    its(:content) { should match(/SSL_GET/) }
  end

  describe file('/etc/keepalived/checks.d/keepalived_tcp_check__port-6379__.conf') do
    its(:content) { should match(/TCP_CHECK/) }
  end
end
