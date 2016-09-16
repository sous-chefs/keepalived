require 'spec_helper'

describe 'keepalived::install' do
  context 'default do' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
    end

    it 'installs the keepalived package' do
      expect(chef_run).to install_package 'keepalived'
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
