require 'spec_helper'

describe 'keepalived::configure' do
  context 'shared address' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['keepalived']['shared_address'] = true
      end.converge(described_recipe)
    end

    it 'sets net.ipv4.ip_nonlocal_bind sysctl' do
      expect(chef_run).to create_file('/etc/sysctl.d/60-ip-nonlocal-bind.conf').with(
        mode: '0644',
        content: "net.ipv4.ip_nonlocal_bind=1\n"
      )
      expect(chef_run).to start_service 'procps'
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'resource-driven' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['keepalived']['use_attributes'] = false
      end.converge(described_recipe)
    end

    it 'skips net.ipv4.ip_nonlocal_bind sysctl management' do
      expect(chef_run).to_not create_file '/etc/sysctl.d/60-ip-nonlocal-bind.conf'
      expect(chef_run).to_not start_service 'procps'
    end

    it 'creates the resource-driven resources' do
      %w( conf.d servers.d checks.d ).each do |d|
        expect(chef_run).to create_directory("/etc/keepalived/#{d}").with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
      end

      expect(chef_run).to create_file('keepalived.conf').with(
        path: '/etc/keepalived/keepalived.conf',
        content: "include /etc/keepalived/conf.d/*.conf\n",
        owner: 'root',
        group: 'root',
        mode: '0640'
      )
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
