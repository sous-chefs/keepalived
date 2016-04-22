require 'spec_helper'

describe 'keepalived::configure' do
  context 'resource-driven' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.set['keepalived']['use_attributes'] = false
      end.converge(described_recipe)
    end

    it 'creates the resource-driven resource include dirs' do
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
        mode: '0644'
      )
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
