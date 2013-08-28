require_relative './helpers.rb'

describe_recipe 'keepalived_test::configured' do

  include KeepalivedHelpers

  describe 'configured keepalived' do
    it 'should create a keepalived configuration file' do
      file('/etc/keepalived/keepalived.conf').must_exist
    end

    it 'should enable and start the daemon' do
      service('keepalived').must_be_running
      service('keepalived').must_be_enabled
    end

    it 'should provide configuration to allow nonlocal ip binds' do
      file('/etc/sysctl.d/60-ip-nonlocal-bind.conf').must_match(
        %r{net\.ipv4\.ip_nonlocal_bind=1}
      )
    end

    it 'should allow nonlocal ip binds' do
      assert_equal(
        1, `sysctl net.ipv4.ip_nonlocal_bind`.strip.split('=').last.strip.to_i,
        'System is not configured to allow non-local binds'
      )
    end

    it 'should have virtual address bound' do
      sleep(5) # give keepalived some time to get setup
      refute_nil(
        `ip addr sh eth0`.split("\n").detect{|l| l.include?('10.0.2.254')},
        'Expected bound virtual IP address not found'
      )
    end

  end
end
