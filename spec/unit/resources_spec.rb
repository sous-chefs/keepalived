# require 'spec_helper'

# describe ChefKeepalived::Resource::Config do
#   let(:config) do
#     ChefKeepalived::Resource::Config.new('my config').tap do |c|
#       c.content 'linkbeat_use_polling'
#     end
#   end

#   it 'sets the proper path' do
#     expect(config.path).to eq '/etc/keepalived/conf.d/keepalived_config__my-config__.conf'
#   end
# end

# describe ChefKeepalived::Resource::VrrpInstance do
#   let(:vrrp_instance) do
#     ChefKeepalived::Resource::VrrpInstance.new('inside_network').tap do |r|
#       r.master true
#       r.interface 'eth0'
#       r.use_vmac 'vrrp.51'
#       r.vmac_xmit_base true
#       r.dont_track_primary true
#       r.track_interface %w( eth0 )
#       r.mcast_src_ip '192.168.1.1'
#       r.unicast_src_ip '192.168.1.1'
#       r.unicast_peer %w( 192.168.1.2 192.168.1.3 )
#       r.lvs_sync_daemon_interface 'eth1'
#       r.garp_master_delay 10
#       r.virtual_router_id 51
#       r.priority 90
#       r.advert_int 5
#       r.authentication auth_type: 'PASS', auth_pass: 'buttz'
#       r.virtual_ipaddress %w( 192.168.1.11 192.168.1.12 192.168.1.13 )
#       r.virtual_ipaddress_excluded %w( 192.168.1.12 192.168.1.13 )
#       r.virtual_routes [
#         'src 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1',
#         '192.168.110.0/24 via 192.168.200.254 dev eth1',
#       ]
#       r.nopreempt true
#       r.preempt_delay 30
#       r.debug true
#     end
#   end

#   let(:vrrp_instance_auth_as_strings) do
#     vrrp_instance.authentication 'auth_type' => 'PASS', 'auth_pass' => 'buttz'
#     vrrp_instance
#   end

#   let(:vrrp_instance_string) do
#     "vrrp_instance inside_network {\n\tstate MASTER\n\tvirtual_router_id 51\n\tinterface eth0\n\tuse_vmac vrrp.51\n\tvmac_xmit_base\n\tdont_track_primary\n\ttrack_interface {\n\t\teth0\n\t\t}\n\tmcast_src_ip 192.168.1.1\n\tunicast_src_ip 192.168.1.1\n\tunicast_peer {\n\t\t192.168.1.2\n\t\t192.168.1.3\n\t\t}\n\tlvs_sync_daemon_interface eth1\n\tgarp_master_delay 10\n\tpriority 90\n\tadvert_int 5\n\tauthentication {\n\t\tauth_type PASS\n\t\tauth_pass buttz\n\t\t}\n\tvirtual_ipaddress {\n\t\t192.168.1.11\n\t\t192.168.1.12\n\t\t192.168.1.13\n\t\t}\n\tvirtual_ipaddress_excluded {\n\t\t192.168.1.12\n\t\t192.168.1.13\n\t\t}\n\tvirtual_routes {\n\t\tsrc 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1\n\t\t192.168.110.0/24 via 192.168.200.254 dev eth1\n\t\t}\n\tnopreempt\n\tpreempt_delay 30\n\tdebug\n\t}"
#   end

#   it 'sets a proper vrrp_instance configuration' do
#     expect(vrrp_instance.content).to eq vrrp_instance_string
#   end

#   it 'allows strings as keys in the authentication hash' do
#     expect(vrrp_instance_auth_as_strings.content).to eq vrrp_instance_string
#   end
# end
