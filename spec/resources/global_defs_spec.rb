require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

global_defs_config_file = '/etc/keepalived/conf.d/global_defs.conf'

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_global_defs on #{platform}" do
    step_into :keepalived_global_defs
    platform platform

    context 'Create a base config correctly' do
      recipe do
        keepalived_global_defs 'global_defs' do
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(global_defs_config_file).with_content(/global_defs\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        expect(chef_run).to create_template(global_defs_config_file).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'Create a config file with notification settings' do
      recipe do
        keepalived_global_defs 'global_defs' do
          notification_email_from 'root@mynode'
          notification_email %w(team@example.com team2@example.com)
          smtp_server 'mysmtpserver'
          smtp_helo_name 'mynode'
          smtp_connect_timeout 10
        end
      end

      describe 'should render config file with the notification sections' do
        it {
          is_expected.to render_file(global_defs_config_file)
            .with_content(/notification_email_from root\@mynode/)
            .with_content(/notification_email\s+\{\s+team\@example\.com\s+team2\@example\.com\s+\}/m)
            .with_content(/smtp_server mysmtpserver/)
            .with_content(/smtp_helo_name mynode/)
            .with_content(/smtp_connect_timeout 10/)
        }
      end
    end

    context 'Create a config with vrrp settings' do
      recipe do
        keepalived_global_defs 'global_defs' do
          router_id 'mynode'
          vrrp_mcast_group4 '224.0.0.18'
          vrrp_mcast_group6 'ff02::12'
          vrrp_garp_master_delay 10
          vrrp_garp_master_repeat 1
          vrrp_garp_master_refresh 60
          vrrp_garp_master_refresh_repeat 2
          vrrp_version 2
          vrrp_iptables 'customName'
          vrrp_check_unicast_src true
          vrrp_strict true
          vrrp_priority 3
          checker_priority 4
          vrrp_no_swap true
          checker_no_swap true
        end
      end

      describe 'should render config file with the vrrp sections' do
        it {
          is_expected.to render_file(global_defs_config_file)
            .with_content(/router_id mynode/)
            .with_content(/vrrp_mcast_group4 224\.0\.0\.18/)
            .with_content(/vrrp_mcast_group6 ff02::12/)
            .with_content(/vrrp_garp_master_delay 10/)
            .with_content(/vrrp_garp_master_repeat 1/)
            .with_content(/vrrp_garp_master_refresh 60/)
            .with_content(/vrrp_garp_master_refresh_repeat 2/)
            .with_content(/vrrp_version 2/)
            .with_content(/vrrp_iptables customName/)
            .with_content(/vrrp_check_unicast_src/)
            .with_content(/vrrp_strict/)
            .with_content(/vrrp_priority 3/)
            .with_content(/checker_priority 4/)
            .with_content(/vrrp_no_swap/)
            .with_content(/checker_no_swap/)
        }
      end
    end

    context 'Create a config with snmp settings' do
      recipe do
        keepalived_global_defs 'global_defs' do
          snmp_socket 'unix:/var/agentx/master'
          enable_snmp_checker true
          enable_snmp_rfc true
          enable_snmp_rfcv2 true
          enable_snmp_rfcv3 true
          enable_traps true
          enable_script_security true
        end
      end

      describe 'should render config file with the snmp sections' do
        it {
          is_expected.to render_file(global_defs_config_file)
            .with_content(%r{snmp_socket unix\:/var/agentx/master})
            .with_content(/enable_snmp_checker/)
            .with_content(/enable_snmp_rfc/)
            .with_content(/enable_snmp_rfcv2/)
            .with_content(/enable_snmp_rfcv3/)
            .with_content(/enable_traps/)
            .with_content(/enable_script_security/)
        }
      end
    end

    context 'Create a config with custom settings' do
      recipe do
        global_defs_extra_options = {
          listOfStuff: %w(foo bar),
          setting: 1,
        }
        keepalived_global_defs 'global_defs' do
          extra_options global_defs_extra_options
        end
      end

      describe 'should render config file with the snmp sections' do
        it {
          is_expected.to render_file(global_defs_config_file)
            .with_content(/listOfStuff\s+\{\s+foo\s+bar\s+\}/m)
            .with_content(/setting 1/)
        }
      end
    end
  end
end
