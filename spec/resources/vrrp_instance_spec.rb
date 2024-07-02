require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def vrrp_instance_file_name(name)
  "/etc/keepalived/conf.d/keepalived_vrrp_instance__#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_vrrp_instance on #{platform}" do
    step_into :keepalived_vrrp_instance
    platform platform

    context 'Create a base config correctly' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'password123!' }
      file_name = vrrp_instance_file_name(instance_name)
      recipe do
        keepalived_vrrp_instance instance_name do
          authentication auth
          virtual_router_id 1
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/vrrp_instance #{instance_name}\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for virtual_router_id, master, interface, use_vmac and vmac_xmit_base' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'password123!' }
      file_name = vrrp_instance_file_name(instance_name)
      recipe do
        keepalived_vrrp_instance instance_name do
          virtual_router_id 1
          master true
          use_vmac 'vrrp.51'
          vmac_xmit_base true
          authentication auth
        end
      end

      it('should render a config file with the virtual_router_id correctly') do
        is_expected.to render_file(file_name).with_content(/virtual_router_id\s1/)
      end
      it('should render a config file with the state/MASTER correctly') do
        is_expected.to render_file(file_name).with_content(/state\sMASTER/)
      end
      it('should render a config file with the use_vmac correctly') do
        is_expected.to render_file(file_name).with_content(/use_vmac\svrrp\.51/)
      end
      it('should render a config file with the vmac_xmit_base correctly') do
        is_expected.to render_file(file_name).with_content(/vmac_xmit_base/)
      end
    end

    context 'When given inputs for dont_track_primary, track_interface, mcast_src_ip, unicast_src_ip and unicast_peer' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'password123!' }
      file_name = vrrp_instance_file_name(instance_name)
      recipe do
        keepalived_vrrp_instance instance_name do
          virtual_router_id 1
          dont_track_primary true
          track_interface %w( eth0 )
          mcast_src_ip '192.168.1.1'
          unicast_src_ip '192.168.1.1'
          unicast_peer %w( 192.168.1.2 192.168.1.3 )
          authentication auth
        end
      end

      it('should render a config file with the dont_track_primary correctly') do
        is_expected.to render_file(file_name).with_content(/dont_track_primary/)
      end
      it('should render a config file with the track_interface correctly') do
        is_expected.to render_file(file_name).with_content(/track_interface\s\{\s+eth0\s+\}/)
      end
      it('should render a config file with the mcast_src_ip correctly') do
        is_expected.to render_file(file_name).with_content(/mcast_src_ip\s192\.168\.1\.1/)
      end
      it('should render a config file with the unicast_src_ip correctly') do
        is_expected.to render_file(file_name).with_content(/unicast_src_ip\s192\.168\.1\.1/)
      end
      it('should render a config file with the unicast_peer correctly') do
        is_expected.to render_file(file_name).with_content(/unicast_peer\s\{\s+192\.168\.1\.2\s+192\.168\.1\.3\s+\}/)
      end
    end

    context 'When given inputs for garp_master_delay, garp_master_repeat, garp_master_refresh_repeat, garp_master_refresh_repeat and priority' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'password123!' }
      file_name = vrrp_instance_file_name(instance_name)
      recipe do
        keepalived_vrrp_instance instance_name do
          virtual_router_id 1
          garp_master_delay 2
          garp_master_repeat 5
          garp_master_refresh 10
          garp_master_refresh_repeat 20
          priority 1
          authentication auth
        end
      end

      it('should render a config file with the garp_master_delay correctly') do
        is_expected.to render_file(file_name).with_content(/garp_master_delay\s2/)
      end
      it('should render a config file with the garp_master_repeat correctly') do
        is_expected.to render_file(file_name).with_content(/garp_master_repeat\s5/)
      end
      it('should render a config file with the garp_master_refresh correctly') do
        is_expected.to render_file(file_name).with_content(/garp_master_refresh\s10/)
      end
      it('should render a config file with the garp_master_refresh_repeat correctly') do
        is_expected.to render_file(file_name).with_content(/garp_master_refresh_repeat\s20/)
      end
      it('should render a config file with the priority correctly') do
        is_expected.to render_file(file_name).with_content(/priority\s1/)
      end
    end

    context 'When given inputs for advert_int, authentication, virtual_ipaddress, virtual_ipaddress_excluded, virtual_routes and virtual_rules' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'secret' }
      file_name = vrrp_instance_file_name(instance_name)
      virtual_routes = [
        'src 192.168.100.1 to 192.168.109.0/24 via 192.168.200.254 dev eth1',
        '192.168.110.0/24 via 192.168.200.254 dev eth1',
      ]
      virtual_rules = [
        'from 192.168.2.0/24 table 1',
        'to 192.168.2.0/24 table 1 no_track',
      ]
      recipe do
        keepalived_vrrp_instance instance_name do
          virtual_router_id 1
          advert_int 5
          virtual_ipaddress %w( 192.168.1.11 192.168.1.12 192.168.1.13 )
          virtual_ipaddress_excluded %w( 192.168.1.12 192.168.1.13 )
          virtual_routes virtual_routes
          virtual_rules virtual_rules
          authentication auth
        end
      end

      it('should render a config file with the advert_int correctly') do
        is_expected.to render_file(file_name).with_content(/advert_int\s5/)
      end
      it('should render a config file with the virtual_ipaddress correctly') do
        is_expected.to render_file(file_name).with_content(/virtual_ipaddress\s\{\s+192\.168\.1\.11\s+192\.168\.1\.12\s+192\.168\.1\.13\s+\}/)
      end
      it('should render a config file with the virtual_ipaddress_excluded correctly') do
        is_expected.to render_file(file_name).with_content(/virtual_ipaddress_excluded\s\{\s+192\.168\.1\.12\s+192\.168\.1\.13\s+\}/)
      end
      it('should render a config file with the virtual_routes correctly') do
        is_expected.to render_file(file_name).with_content(%r{virtual_routes\s\{\s+src\s192\.168\.100\.1\sto\s192\.168\.109\.0/24\svia\s192\.168\.200\.254\sdev\seth1\s+192\.168\.110\.0/24\svia\s192\.168\.200\.254\sdev\seth1\s+\}})
      end
      it('should render a config file with the virtual_rules correctly') do
        is_expected.to render_file(file_name).with_content(%r{virtual_rules\s\{\s+from\s192\.168\.2\.0/24\stable\s1\s+to\s192\.168\.2\.0/24\stable\s1\sno_track\s+\}})
      end
      it('should render a config file with the authentication correctly') do
        is_expected.to render_file(file_name).with_content(/authentication\s\{\s+auth_type\sPASS\s+auth_pass\ssecret\s+\}/)
      end
    end

    context 'When given inputs for track_script, nopreempt, preempt_delay, strict_mode, version and native_ipv6' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'password123!' }
      file_name = vrrp_instance_file_name(instance_name)
      recipe do
        keepalived_vrrp_instance instance_name do
          authentication auth
          virtual_router_id 1
          track_script %w( /opt/myscript.sh )
          nopreempt true
          preempt_delay 500
          strict_mode true
          version 3
          native_ipv6 true
        end
      end

      it('should render a config file with the track_script correctly') do
        is_expected.to render_file(file_name).with_content(%r{track_script\s\{\s+/opt/myscript\.sh\s+\}})
      end
      it('should render a config file with the nopreempt correctly') do
        is_expected.to render_file(file_name).with_content(/nopreempt/)
      end
      it('should render a config file with the preempt_delay correctly') do
        is_expected.to render_file(file_name).with_content(/preempt_delay\s500/)
      end
      it('should render a config file with the strict_mode correctly') do
        is_expected.to render_file(file_name).with_content(/strict_mode\strue/)
      end
      it('should render a config file with the version correctly') do
        is_expected.to render_file(file_name).with_content(/version\s3/)
      end
      it('should render a config file with the native_ipv6 correctly') do
        is_expected.to render_file(file_name).with_content(/native_ipv6/)
      end
    end

    context 'When given inputs for notify_stop, notify_master, notify_backup, notify_fault, notify and smtp_alert' do
      cached(:subject) { chef_run }
      instance_name = 'insideNetwork'
      auth = { auth_type: 'PASS', auth_pass: 'password123!' }
      file_name = vrrp_instance_file_name(instance_name)
      recipe do
        keepalived_vrrp_instance instance_name do
          authentication auth
          virtual_router_id 1
          notify_stop   '/path/to_stop.sh'
          notify_master '/path/to_master.sh'
          notify_backup '/path/to_backup.sh'
          notify_fault  '/path/fault.sh'
          notify        '/path/notify.sh'
          smtp_alert    true
        end
      end

      it('should render a config file with the notify_stop correctly') do
        is_expected.to render_file(file_name).with_content{|s|
          expect(s.scan(%r{notify_stop\s/path/to_stop\.sh}).size).to eq(1)
        }

      end

      it('should render a config file with the notify_master correctly') do
        is_expected.to render_file(file_name).with_content{|s|
          expect(s.scan(%r{notify_master\s/path/to_master\.sh}).size).to eq(1)
        }
      end

      it('should render a config file with the notify_backup correctly') do
        is_expected.to render_file(file_name).with_content{|s|
          expect(s.scan(%r{notify_backup\s/path/to_backup\.sh}).size).to eq(1)
        }
      end

      it('should render a config file with the notify_fault correctly') do
        is_expected.to render_file(file_name).with_content{|s|
          expect(s.scan(%r{notify_fault\s/path/fault\.sh}).size).to eq(1)
        }
      end

      it('should render a config file with the notify correctly') do
        is_expected.to render_file(file_name).with_content{|s|
          expect(s.scan(%r{notify\s/path/notify\.sh}).size).to eq(1)
        }
      end

      it('should render a config file with the smtp_alert set to true') do
        is_expected.to render_file(file_name).with_content(/smtp_alert\strue/)
      end
    end
  end
end
