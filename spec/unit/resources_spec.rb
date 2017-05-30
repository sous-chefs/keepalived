require 'spec_helper'

describe ChefKeepalived::Resource::Config do
  let(:config) do
    ChefKeepalived::Resource::Config.new('my config').tap do |c|
      c.content 'linkbeat_use_polling'
    end
  end

  it 'sets the proper path' do
    expect(config.path).to eq '/etc/keepalived/conf.d/keepalived_config__my-config__.conf'
  end
end

describe ChefKeepalived::Resource::GlobalDefs do
  let(:global_defs) do
    ChefKeepalived::Resource::GlobalDefs.new('global_defs').tap do |r|
      r.notification_email %w( me@example.com root@localhost )
      r.notification_email_from 'keepalived@localhost'
      r.smtp_server '127.0.0.1'
      r.smtp_connect_timeout 30
      r.router_id 'my_router_id'
      r.vrrp_mcast_group4 '224.0.0.18'
      r.vrrp_mcast_group6 'ff02::12'
      r.enable_traps true
    end
  end

  let(:global_defs_string) do
    "global_defs {\n\tnotification_email {\n\t\tme@example.com\n\t\troot@localhost\n\t\t}\n\tnotification_email_from keepalived@localhost\n\tsmtp_server 127.0.0.1\n\tsmtp_connect_timeout 30\n\trouter_id my_router_id\n\tvrrp_mcast_group4 224.0.0.18\n\tvrrp_mcast_group6 ff02::12\n\tenable_traps\n\t}"
  end

  it 'sets a proper global_defs configuration' do
    expect(global_defs.content).to eq global_defs_string
  end
end

describe ChefKeepalived::Resource::StaticIpAddress do
  let(:static_ipaddress) do
    ChefKeepalived::Resource::StaticIpAddress.new('static_ipaddress').tap do |r|
      r.addresses [
        '192.168.1.98/24 dev eth0 scope global',
        '192.168.1.99/24 dev eth0 scope global',
      ]
    end
  end

  let(:static_ipaddress_string) do
    "static_ipaddress {\n\t192.168.1.98/24 dev eth0 scope global\n\t192.168.1.99/24 dev eth0 scope global\n\t}"
  end

  it 'sets a proper static_ipaddress configuration' do
    expect(static_ipaddress.content).to eq static_ipaddress_string
  end
end

describe ChefKeepalived::Resource::StaticRoutes do
  let(:static_routes) do
    ChefKeepalived::Resource::StaticRoutes.new('static_routes').tap do |r|
      r.routes [
        '192.168.2.0/24 via 192.168.1.100 dev eth0',
        '192.168.3.0/24 via 192.168.1.200 dev eth0',
      ]
    end
  end

  let(:static_routes_string) do
    "static_routes {\n\t192.168.2.0/24 via 192.168.1.100 dev eth0\n\t192.168.3.0/24 via 192.168.1.200 dev eth0\n\t}"
  end

  it 'sets a proper static_routes configuration' do
    expect(static_routes.content).to eq static_routes_string
  end
end

describe ChefKeepalived::Resource::VrrpSyncGroup do
  let(:vrrp_sync_group) do
    ChefKeepalived::Resource::VrrpSyncGroup.new('VG_1').tap do |r|
      r.group %w( inside_network outside_network )
      r.notify_master '/usr/local/bin/keepalived-notify-master.sh'
      r.notify_backup '/usr/local/bin/keepalived-notify-backup.sh'
      r.notify_fault '/usr/local/bin/keepalived-notify-fault.sh'
      r.notify '/usr/local/bin/keepalived-notify.sh'
      r.smtp_alert true
    end
  end

  let(:vrrp_sync_group_string) do
    "vrrp_sync_group VG_1 {\n\tnotify_master /usr/local/bin/keepalived-notify-master.sh\n\tnotify_backup /usr/local/bin/keepalived-notify-backup.sh\n\tnotify_fault /usr/local/bin/keepalived-notify-fault.sh\n\tnotify /usr/local/bin/keepalived-notify.sh\n\tsmtp_alert\n\tgroup {\n\t\tinside_network\n\t\toutside_network\n\t\t}\n\t}"
  end

  it 'sets a proper vrrp_sync_group configuration' do
    expect(vrrp_sync_group.content).to eq vrrp_sync_group_string
  end
end

describe ChefKeepalived::Resource::VrrpScript do
  let(:vrrp_script) do
    ChefKeepalived::Resource::VrrpScript.new('chk_haproxy').tap do |r|
      r.script '/usr/local/bin/chk-haproxy.sh'
      r.interval 2
      r.weight 50
    end
  end

  let(:vrrp_script_string) do
    "vrrp_script chk_haproxy {\n\tscript /usr/local/bin/chk-haproxy.sh\n\tinterval 2\n\tweight 50\n\t}"
  end

  it 'sets a proper vrrp_script configuration' do
    expect(vrrp_script.content).to eq vrrp_script_string
  end

  it 'overrides the path to force the load order' do
    expect(vrrp_script.path).to eq('/etc/keepalived/conf.d/00_keepalived_vrrp_script__chk_haproxy__.conf')
  end
end

describe ChefKeepalived::Resource::VrrpInstance do
  let(:vrrp_instance) do
    ChefKeepalived::Resource::VrrpInstance.new('inside_network').tap do |r|
      r.master true
      r.interface 'eth0'
      r.use_vmac 'vrrp.51'
      r.vmac_xmit_base true
      r.dont_track_primary true
      r.track_interface %w( eth0 )
      r.mcast_src_ip '192.168.1.1'
      r.unicast_src_ip '192.168.1.1'
      r.unicast_peer %w( 192.168.1.2 192.168.1.3 )
      r.lvs_sync_daemon_interface 'eth1'
      r.garp_master_delay 10
      r.virtual_router_id 51
      r.priority 90
      r.advert_int 5
      r.authentication auth_type: 'PASS', auth_pass: 'buttz'
      r.virtual_ipaddress %w( 192.168.1.11 192.168.1.12 192.168.1.13 )
      r.virtual_ipaddress_excluded %w( 192.168.1.12 192.168.1.13 )
      r.virtual_routes [
        'src 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1',
        '192.168.110.0/24 via 192.168.200.254 dev eth1',
      ]
      r.nopreempt true
      r.preempt_delay 30
      r.debug true
    end
  end

  let(:vrrp_instance_auth_as_strings) do
    vrrp_instance.authentication 'auth_type' => 'PASS', 'auth_pass' => 'buttz'
    vrrp_instance
  end

  let(:vrrp_instance_string) do
    "vrrp_instance inside_network {\n\tstate MASTER\n\tvirtual_router_id 51\n\tinterface eth0\n\tuse_vmac vrrp.51\n\tvmac_xmit_base\n\tdont_track_primary\n\ttrack_interface {\n\t\teth0\n\t\t}\n\tmcast_src_ip 192.168.1.1\n\tunicast_src_ip 192.168.1.1\n\tunicast_peer {\n\t\t192.168.1.2\n\t\t192.168.1.3\n\t\t}\n\tlvs_sync_daemon_interface eth1\n\tgarp_master_delay 10\n\tpriority 90\n\tadvert_int 5\n\tauthentication {\n\t\tauth_type PASS\n\t\tauth_pass buttz\n\t\t}\n\tvirtual_ipaddress {\n\t\t192.168.1.11\n\t\t192.168.1.12\n\t\t192.168.1.13\n\t\t}\n\tvirtual_ipaddress_excluded {\n\t\t192.168.1.12\n\t\t192.168.1.13\n\t\t}\n\tvirtual_routes {\n\t\tsrc 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1\n\t\t192.168.110.0/24 via 192.168.200.254 dev eth1\n\t\t}\n\tnopreempt\n\tpreempt_delay 30\n\tdebug\n\t}"
  end

  it 'sets a proper vrrp_instance configuration' do
    expect(vrrp_instance.content).to eq vrrp_instance_string
  end

  it 'allows strings as keys in the authentication hash' do
    expect(vrrp_instance_auth_as_strings.content).to eq vrrp_instance_string
  end
end

describe ChefKeepalived::Resource::VirtualServerGroup do
  let(:virtual_server_group) do
    ChefKeepalived::Resource::VirtualServerGroup.new('http').tap do |r|
      r.vips ['192.168.200.1-10 80', '192.168.201.1-10 8080']
      r.fwmarks 1.upto(3).to_a
    end
  end

  let(:virtual_server_group_string) do
    "virtual_server_group http {\n\t192.168.200.1-10 80\n\t192.168.201.1-10 8080\n\tfwmark 1\n\tfwmark 2\n\tfwmark 3\n\t}"
  end

  it 'sets a proper virtual_server_group configuration' do
    expect(virtual_server_group.content).to eq virtual_server_group_string
  end
end

describe ChefKeepalived::Resource::VirtualServer do
  let(:virtual_server) do
    ChefKeepalived::Resource::VirtualServer.new('web').tap do |r|
      r.delay_loop 5
      r.lb_algo 'rr'
      r.ops true
      r.lb_kind 'NAT'
      r.persistence_timeout 1_800
      r.persistence_granularity '255.255.255.0'
      r.protocol 'TCP'
      r.ha_suspend true
      r.virtualhost 'www.example.com'
      r.alpha true
      r.omega true
      r.quorum 2
      r.hysteresis 1
      r.quorum_up '/usr/local/bin/keepalived-quorum-up.sh'
      r.quorum_down '/usr/local/bin/keepalived-quorum-down.sh'
      r.sorry_server '127.0.0.1 8080'
      r.sorry_server_inhibit true
      r.real_servers %w( fe01 fe02 fe03 ).map { |n| "/etc/keepalived/servers.d/#{n}.conf" }
    end
  end

  let(:virtual_server_string) do
    "virtual_server web {\n\tdelay_loop 5\n\tlb_algo rr\n\tops\n\tlb_kind NAT\n\tpersistence_timeout 1800\n\tpersistence_granularity 255.255.255.0\n\tprotocol TCP\n\tha_suspend\n\tvirtualhost www.example.com\n\talpha\n\tomega\n\tquorum 2\n\thysteresis 1\n\tquorum_up /usr/local/bin/keepalived-quorum-up.sh\n\tquorum_down /usr/local/bin/keepalived-quorum-down.sh\n\tsorry_server 127.0.0.1 8080\n\tsorry_server_inhibit\n\tinclude /etc/keepalived/servers.d/fe01.conf\n\tinclude /etc/keepalived/servers.d/fe02.conf\n\tinclude /etc/keepalived/servers.d/fe03.conf\n\t}"
  end

  it 'sets a proper virtual_server configuration' do
    expect(virtual_server.content).to eq virtual_server_string
  end
end

describe ChefKeepalived::Resource::RealServer do
  let(:real_server) do
    ChefKeepalived::Resource::RealServer.new('fe01').tap do |r|
      r.ipaddress '192.168.1.1'
      r.port 80
      r.weight 2
      r.inhibit_on_failure true
      r.notify_up '/usr/local/bin/keepalived-notify-up.sh'
      r.notify_down '/usr/local/bin/keepalived-notify-down.sh'
      r.healthcheck '/etc/keepalived/checks.d/fe-http.conf'
    end
  end

  let(:real_server_string) do
    "real_server 192.168.1.1 80 {\n\tweight 2\n\tinhibit_on_failure\n\tnotify_up /usr/local/bin/keepalived-notify-up.sh\n\tnotify_down /usr/local/bin/keepalived-notify-down.sh\n\tinclude /etc/keepalived/checks.d/fe-http.conf\n\t}"
  end

  it 'sets a proper real_server configuration' do
    expect(real_server.content).to eq real_server_string
  end
end

describe ChefKeepalived::Resource::TcpCheck do
  let(:tcp_check) do
    ChefKeepalived::Resource::TcpCheck.new('port-3306').tap do |r|
      r.connect_ip '192.168.1.20'
      r.connect_port 3306
      r.bindto '192.168.1.5'
      r.bind_port 3308
      r.connect_timeout 5
      r.fwmark 3
    end
  end

  let(:tcp_check_string) do
    "TCP_CHECK {\n\tconnect_ip 192.168.1.20\n\tconnect_port 3306\n\tbindto 192.168.1.5\n\tbind_port 3308\n\tconnect_timeout 5\n\tfwmark 3\n\t}"
  end

  it 'sets a proper tcp_check configuration' do
    expect(tcp_check.content).to eq tcp_check_string
  end
end

describe ChefKeepalived::Resource::HttpGet do
  let(:http_get) do
    ChefKeepalived::Resource::HttpGet.new('port-80').tap do |r|
      r.connect_ip '192.168.1.20'
      r.connect_port 3306
      r.bindto '192.168.1.5'
      r.bind_port 3308
      r.connect_timeout 5
      r.fwmark 3
      r.nb_get_retry 3
      r.delay_before_retry 5
      r.warmup 3
      r.url(
        path: '/health_check',
        digest: '9b3a0c85a887a256d6939da88aabd8cd',
        status_code: 200
      )
    end
  end

  let(:http_get_string) do
    "HTTP_GET {\n\tconnect_ip 192.168.1.20\n\tconnect_port 3306\n\tbindto 192.168.1.5\n\tbind_port 3308\n\tconnect_timeout 5\n\tfwmark 3\n\twarmup 3\n\turl {\n\t\tpath /health_check\n\t\tdigest 9b3a0c85a887a256d6939da88aabd8cd\n\t\tstatus_code 200\n\t\t}\n\tnb_get_retry 3\n\tdelay_before_retry 5\n\t}"
  end

  it 'sets a proper http_get configuration' do
    expect(http_get.content).to eq http_get_string
  end
end

describe ChefKeepalived::Resource::SslGet do
  let(:ssl_get) do
    ChefKeepalived::Resource::SslGet.new('port-443').tap do |r|
      r.connect_ip '192.168.1.20'
      r.connect_port 3306
      r.bindto '192.168.1.5'
      r.bind_port 3308
      r.connect_timeout 5
      r.fwmark 3
      r.nb_get_retry 3
      r.delay_before_retry 5
      r.warmup 3
      r.url(
        path: '/health_check',
        digest: '9b3a0c85a887a256d6939da88aabd8cd',
        status_code: 200
      )
    end
  end

  let(:ssl_get_string) do
    "SSL_GET {\n\tconnect_ip 192.168.1.20\n\tconnect_port 3306\n\tbindto 192.168.1.5\n\tbind_port 3308\n\tconnect_timeout 5\n\tfwmark 3\n\twarmup 3\n\turl {\n\t\tpath /health_check\n\t\tdigest 9b3a0c85a887a256d6939da88aabd8cd\n\t\tstatus_code 200\n\t\t}\n\tnb_get_retry 3\n\tdelay_before_retry 5\n\t}"
  end

  it 'sets a proper ssl_get configuration' do
    expect(ssl_get.content).to eq ssl_get_string
  end
end

describe ChefKeepalived::Resource::SmtpCheck do
  let(:smtp_check) do
    ChefKeepalived::Resource::SmtpCheck.new('port-465').tap do |r|
      r.delay_before_retry 10
      r.helo_name 'smtp.example.com'
      r.warmup 3
      r.host(
        connect_ip: '192.168.1.20',
        connect_port: 3306,
        bindto: '192.168.1.5',
        bind_port: 3308,
        connect_timeout: 5,
        fwmark: 3
      )
    end
  end

  let(:smtp_check_string) do
    "SMTP_CHECK {\n\twarmup 3\n\thost {\n\t\tconnect_ip 192.168.1.20\n\t\tconnect_port 3306\n\t\tbindto 192.168.1.5\n\t\tbind_port 3308\n\t\tconnect_timeout 5\n\t\tfwmark 3\n\t\t}\n\tdelay_before_retry 10\n\thelo_name smtp.example.com\n\t}"
  end

  it 'sets a proper smtp_check configuration' do
    expect(smtp_check.content).to eq smtp_check_string
  end
end

describe ChefKeepalived::Resource::MiscCheck do
  let(:misc_check) do
    ChefKeepalived::Resource::MiscCheck.new('misc').tap do |r|
      r.misc_path '/usr/local/bin/keepalived-misc-check.sh'
      r.misc_timeout 10
      r.warmup 3
      r.misc_dynamic true
    end
  end

  let(:misc_check_string) do
    "MISC_CHECK {\n\tmisc_path /usr/local/bin/keepalived-misc-check.sh\n\tmisc_timeout 10\n\twarmup 3\n\tmisc_dynamic\n\t}"
  end

  it 'sets a proper misc_check configuration' do
    expect(misc_check.content).to eq misc_check_string
  end
end
