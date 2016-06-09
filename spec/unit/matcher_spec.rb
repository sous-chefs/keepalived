require 'spec_helper'

# Genereated with:
# grep resource_name libraries/resources.rb | perl -ne 's,.*keepalived_,,; chomp; printf<<EOF
# it "should have a matcher for the %s resource" do
#   expect(ChefSpec.matchers).to have_key :keepalived_%s
# end
#
# it "should define matcher methods for the %s resource" do
#   expect(ChefSpec).to respond_to :create_keepalived_%s
#   expect(ChefSpec).to respond_to :delete_keepalived_%s
# end\n
# EOF
# , ($_) x 6;'

describe ChefSpec do
  it 'should have a matcher for the config resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_config
  end

  it 'should define matcher methods for the config resource' do
    expect(ChefSpec).to respond_to :create_keepalived_config
    expect(ChefSpec).to respond_to :delete_keepalived_config
  end

  it 'should have a matcher for the global_defs resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_global_defs
  end

  it 'should define matcher methods for the global_defs resource' do
    expect(ChefSpec).to respond_to :create_keepalived_global_defs
    expect(ChefSpec).to respond_to :delete_keepalived_global_defs
  end

  it 'should have a matcher for the static_ipaddress resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_static_ipaddress
  end

  it 'should define matcher methods for the static_ipaddress resource' do
    expect(ChefSpec).to respond_to :create_keepalived_static_ipaddress
    expect(ChefSpec).to respond_to :delete_keepalived_static_ipaddress
  end

  it 'should have a matcher for the static_routes resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_static_routes
  end

  it 'should define matcher methods for the static_routes resource' do
    expect(ChefSpec).to respond_to :create_keepalived_static_routes
    expect(ChefSpec).to respond_to :delete_keepalived_static_routes
  end

  it 'should have a matcher for the vrrp_sync_group resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_vrrp_sync_group
  end

  it 'should define matcher methods for the vrrp_sync_group resource' do
    expect(ChefSpec).to respond_to :create_keepalived_vrrp_sync_group
    expect(ChefSpec).to respond_to :delete_keepalived_vrrp_sync_group
  end

  it 'should have a matcher for the vrrp_script resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_vrrp_script
  end

  it 'should define matcher methods for the vrrp_script resource' do
    expect(ChefSpec).to respond_to :create_keepalived_vrrp_script
    expect(ChefSpec).to respond_to :delete_keepalived_vrrp_script
  end

  it 'should have a matcher for the vrrp_instance resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_vrrp_instance
  end

  it 'should define matcher methods for the vrrp_instance resource' do
    expect(ChefSpec).to respond_to :create_keepalived_vrrp_instance
    expect(ChefSpec).to respond_to :delete_keepalived_vrrp_instance
  end

  it 'should have a matcher for the virtual_server_group resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_virtual_server_group
  end

  it 'should define matcher methods for the virtual_server_group resource' do
    expect(ChefSpec).to respond_to :create_keepalived_virtual_server_group
    expect(ChefSpec).to respond_to :delete_keepalived_virtual_server_group
  end

  it 'should have a matcher for the virtual_server resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_virtual_server
  end

  it 'should define matcher methods for the virtual_server resource' do
    expect(ChefSpec).to respond_to :create_keepalived_virtual_server
    expect(ChefSpec).to respond_to :delete_keepalived_virtual_server
  end

  it 'should have a matcher for the real_server resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_real_server
  end

  it 'should define matcher methods for the real_server resource' do
    expect(ChefSpec).to respond_to :create_keepalived_real_server
    expect(ChefSpec).to respond_to :delete_keepalived_real_server
  end

  it 'should have a matcher for the tcp_check resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_tcp_check
  end

  it 'should define matcher methods for the tcp_check resource' do
    expect(ChefSpec).to respond_to :create_keepalived_tcp_check
    expect(ChefSpec).to respond_to :delete_keepalived_tcp_check
  end

  it 'should have a matcher for the http_get resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_http_get
  end

  it 'should define matcher methods for the http_get resource' do
    expect(ChefSpec).to respond_to :create_keepalived_http_get
    expect(ChefSpec).to respond_to :delete_keepalived_http_get
  end

  it 'should have a matcher for the ssl_get resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_ssl_get
  end

  it 'should define matcher methods for the ssl_get resource' do
    expect(ChefSpec).to respond_to :create_keepalived_ssl_get
    expect(ChefSpec).to respond_to :delete_keepalived_ssl_get
  end

  it 'should have a matcher for the smtp_check resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_smtp_check
  end

  it 'should define matcher methods for the smtp_check resource' do
    expect(ChefSpec).to respond_to :create_keepalived_smtp_check
    expect(ChefSpec).to respond_to :delete_keepalived_smtp_check
  end

  it 'should have a matcher for the misc_check resource' do
    expect(ChefSpec.matchers).to have_key :keepalived_misc_check
  end

  it 'should define matcher methods for the misc_check resource' do
    expect(ChefSpec).to respond_to :create_keepalived_misc_check
    expect(ChefSpec).to respond_to :delete_keepalived_misc_check
  end
end
