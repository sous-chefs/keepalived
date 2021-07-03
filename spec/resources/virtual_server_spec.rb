require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def virtual_server_file_name(name)
  "/etc/keepalived/conf.d/keepalived_virtual_server__#{name.to_s.gsub(/\s+/, '-')}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_virtual_server on #{platform}" do
    step_into :keepalived_virtual_server
    platform platform

    context 'Create a base config correctly' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for real_servers, ip_family and delay_loop' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          ip_family 'inet'
          delay_loop 5
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the includes for the real_servers') do
        is_expected.to render_file(file_name).with_content(%r{include /etc/keepalived/servers\.d/keepalived_real_server__192\.168\.1\.14-443__\.conf})
      end
      it('should render a config file with the delay_loop correctly') do
        is_expected.to render_file(file_name).with_content(/delay_loop\s5/)
      end
    end

    context 'When given inputs for lvs_sched = rr, ops and lvs_method = NAT' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          lvs_sched 'rr'
          lvs_method 'NAT'
          ops true
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the lvs_sched correctly') do
        is_expected.to render_file(file_name).with_content(/lvs_sched\srr/)
      end
      it('should render a config file with the lvs_method correctly') do
        is_expected.to render_file(file_name).with_content(/lvs_method\sNAT/)
      end
      it('should render a config file with the ops correctly') do
        is_expected.to render_file(file_name).with_content(/ops/)
      end
    end

    context 'When given inputs for lvs_sched = wlc, lvs_method = DR' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          lvs_sched 'wlc'
          lvs_method 'DR'
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the lvs_sched correctly') do
        is_expected.to render_file(file_name).with_content(/lvs_sched\swlc/)
      end
      it('should render a config file with the lvs_method correctly') do
        is_expected.to render_file(file_name).with_content(/lvs_method\sDR/)
      end
    end

    context 'When given inputs for lvs_sched = ovf, ops and lvs_method = DR' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          lvs_sched 'ovf'
          lvs_method 'DR'
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the lvs_sched correctly') do
        is_expected.to render_file(file_name).with_content(/lvs_sched\sovf/)
      end
      it('should render a config file with the lvs_method correctly') do
        is_expected.to render_file(file_name).with_content(/lvs_method\sDR/)
      end
    end
    context 'When given inputs for persistence_engine, persistence_timeout and persistence_granularity' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          persistence_engine 'sip'
          persistence_timeout 30
          persistence_granularity '255.255.0.0'
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the persistence_engine correctly') do
        is_expected.to render_file(file_name).with_content(/persistence_engine\ssip/)
      end
      it('should render a config file with the persistence_timeout correctly') do
        is_expected.to render_file(file_name).with_content(/persistence_timeout\s30/)
      end
      it('should render a config file with the persistence_granularity correctly') do
        is_expected.to render_file(file_name).with_content(/persistence_granularity\s255\.255\.0\.0/)
      end
    end

    context 'When given inputs for protocol, ha_suspend, virtualhost, alpha and omega' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          protocol 'TCP'
          ha_suspend true
          virtualhost 'www.sous-chefs.org'
          alpha true
          omega true
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the protocol correctly') do
        is_expected.to render_file(file_name).with_content(/protocol\sTCP/)
      end
      it('should render a config file with the ha_suspend correctly') do
        is_expected.to render_file(file_name).with_content(/ha_suspend/)
      end
      it('should render a config file with the virtualhost correctly') do
        is_expected.to render_file(file_name).with_content(/virtualhost\swww\.sous\-chefs\.org/)
      end
      it('should render a config file with the alpha correctly') do
        is_expected.to render_file(file_name).with_content(/alpha/)
      end
      it('should render a config file with the omega correctly') do
        is_expected.to render_file(file_name).with_content(/omega/)
      end
    end
    context 'When given inputs for quorum, hysteresis, quorum_up and quorum_down' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          quorum 2
          hysteresis 1
          quorum_up '/usr/local/bin/keepalived-quorum-up.sh'
          quorum_down '/usr/local/bin/keepalived-quorum-down.sh'
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the quorum correctly') do
        is_expected.to render_file(file_name).with_content(/quorum\s2/)
      end
      it('should render a config file with the hysteresis correctly') do
        is_expected.to render_file(file_name).with_content(/hysteresis\s1/)
      end
      it('should render a config file with the quorum_up correctly') do
        is_expected.to render_file(file_name).with_content(%r{quorum_up\s/usr/local/bin/keepalived\-quorum\-up\.sh})
      end
      it('should render a config file with the quorum_down correctly') do
        is_expected.to render_file(file_name).with_content(%r{quorum_down\s/usr/local/bin/keepalived\-quorum\-down\.sh})
      end
    end
    context 'When given inputs for sorry_server and sorry_server_inhibit' do
      cached(:subject) { chef_run }
      ip_address = '192.168.1.1 80'
      file_name = virtual_server_file_name(ip_address)
      real_servers = ['/etc/keepalived/servers.d/keepalived_real_server__192.168.1.14-443__.conf']
      recipe do
        keepalived_virtual_server ip_address do
          real_servers real_servers
          sorry_server '127.0.0.1 8080'
          sorry_server_inhibit true
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server #{ip_address}\s+\{.*\}/m)
      end
      it('should render a config file with the sorry_server correctly') do
        is_expected.to render_file(file_name).with_content(/sorry_server\s127.0.0.1 8080/)
      end
      it('should render a config file with the sorry_server_inhibit correctly') do
        is_expected.to render_file(file_name).with_content(/sorry_server_inhibit/)
      end
    end
  end
end
