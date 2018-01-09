require 'spec_helper'

describe 'keepalived::configure' do
  context 'resource-driven' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'creates the resource-driven resource include dirs' do
      %w( conf.d servers.d checks.d ).each do |d|
        expect(chef_run).to create_directory("/etc/keepalived/#{d}").with(
          owner: 'root',
          group: 'root',
          mode: '0755'
        )
      end

      expect(chef_run).to_not create_file('keepalived-options')

      expect(chef_run).to create_file('keepalived.conf').with(
        path: '/etc/keepalived/keepalived.conf',
        content: "include /etc/keepalived/conf.d/*.conf\n",
        owner: 'root',
        group: 'root',
        mode: '0640'
      )

      expect(chef_run).to create_file('/etc/keepalived/conf.d/empty.conf').with(
        content: '# Some versions of Keepalived won\'t start when include dir is empty',
        owner: 'root',
        group: 'root',
        mode: '0640'
      )
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'daemon-args' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['keepalived']['daemon_args'] = %w( -D --snmp )
      end.converge(described_recipe)
    end

    it 'creates the defaults file' do
      expect(chef_run).to create_file('keepalived-options').with(
        path: '/etc/sysconfig/keepalived',
        owner: 'root',
        group: 'root',
        mode: '0640',
        content: "KEEPALIVED_OPTIONS='-D --snmp'"
      )
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
