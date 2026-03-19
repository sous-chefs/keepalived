# frozen_string_literal: true

require 'spec_helper'

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_install on #{platform}" do
    step_into :keepalived_install
    platform platform

    context 'action :install with default properties' do
      cached(:subject) { chef_run }
      recipe do
        keepalived_install 'keepalived'
      end

      it { is_expected.to install_package('keepalived') }
      it { is_expected.to create_directory('/etc/keepalived/conf.d').with(owner: 'root', group: 'root', mode: '0755') }
      it { is_expected.to create_directory('/etc/keepalived/servers.d').with(owner: 'root', group: 'root', mode: '0755') }
      it { is_expected.to create_directory('/etc/keepalived/checks.d').with(owner: 'root', group: 'root', mode: '0755') }
      it { is_expected.to create_file('keepalived.conf').with(owner: 'root', group: 'root', mode: '0640') }
      it { is_expected.to create_file('/etc/keepalived/conf.d/empty.conf').with(owner: 'root', group: 'root', mode: '0640') }
    end

    context 'action :install with custom properties' do
      cached(:subject) { chef_run }
      recipe do
        keepalived_install 'keepalived' do
          package_name 'keepalived-custom'
          root_path '/opt/keepalived'
        end
      end

      it { is_expected.to install_package('keepalived-custom') }
      it { is_expected.to create_directory('/opt/keepalived/conf.d') }
      it { is_expected.to create_directory('/opt/keepalived/servers.d') }
      it { is_expected.to create_directory('/opt/keepalived/checks.d') }
    end

    context 'action :remove' do
      cached(:subject) { chef_run }
      recipe do
        keepalived_install 'keepalived' do
          action :remove
        end
      end

      it { is_expected.to remove_package('keepalived') }
      it { is_expected.to delete_directory('/etc/keepalived/conf.d') }
      it { is_expected.to delete_directory('/etc/keepalived/servers.d') }
      it { is_expected.to delete_directory('/etc/keepalived/checks.d') }
    end
  end
end
