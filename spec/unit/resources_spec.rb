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
