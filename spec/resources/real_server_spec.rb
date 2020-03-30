require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def real_server_file_name(ipaddress, port)
  "/etc/keepalived/servers.d/keepalived_real_server__#{ipaddress}-#{port}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_real_server on #{platform}" do
    step_into :keepalived_real_server
    platform platform

    context 'Create a base config correctly' do
      ipaddress = '192.168.1.1'
      port = 80
      file_name = real_server_file_name(ipaddress, port)
      recipe do
        keepalived_real_server 'Insecure Web Server' do
          ipaddress ipaddress
          port      port
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/real_server #{ipaddress} #{port}\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        expect(chef_run).to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for notify_up, notify_down and inhibit_on_failure' do
      ipaddress = '192.168.1.2'
      port = 443
      file_name = real_server_file_name(ipaddress, port)
      recipe do
        keepalived_real_server 'Secure Web Server' do
          ipaddress ipaddress
          port      port
          notify_up '/usr/local/bin/keepalived-notify-up.sh'
          notify_down '/usr/local/bin/keepalived-notify-down.sh'
          inhibit_on_failure true
        end
      end

      it('should render a config file with the ipaddress correctly') do
        is_expected.to render_file(file_name).with_content(/real_server #{ipaddress} #{port}\s+\{.*\}/m)
      end
      it('should render a config file with the notify_up script correctly') do
        is_expected.to render_file(file_name).with_content(%r{notify_up\s/usr/local/bin/keepalived-notify-up.sh})
      end
      it('should render a config file with the notify_down script correctly') do
        is_expected.to render_file(file_name).with_content(%r{notify_down\s/usr/local/bin/keepalived-notify-down.sh})
      end
      it('should render a config file with inhibit_on_failure set correctly') do
        is_expected.to render_file(file_name).with_content(/inhibit_on_failure\strue/)
      end
    end

    context 'When given inputs for weight and healthcheck' do
      ipaddress = '192.168.1.3'
      port = 5432
      file_name = real_server_file_name(ipaddress, port)
      recipe do
        keepalived_real_server 'Postgresql Database Server' do
          ipaddress ipaddress
          port      port
          weight    10
          healthcheck '/etc/keepalived/checks.d/fe-http.conf'
        end
      end

      it('should render a config file with the ipaddress correctly') do
        is_expected.to render_file(file_name).with_content(/real_server #{ipaddress} #{port}\s+\{.*\}/m)
      end
      it('should render a config file with the healthcheck using an include statement correctly') do
        is_expected.to render_file(file_name).with_content(%r{include\s/etc/keepalived/checks.d/fe-http.conf})
      end
      it('should render a config file with the notify_down script correctly') do
        is_expected.to render_file(file_name).with_content(/weight\s10/)
      end
    end
  end
end
