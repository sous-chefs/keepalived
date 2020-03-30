require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def tcp_check_file_name(name)
  "/etc/keepalived/checks.d/keepalived_tcp_check__port-#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_tcp_check on #{platform}" do
    step_into :keepalived_tcp_check
    platform platform

    context 'Create a base config correctly' do
      name = 'example-80'
      file_name = tcp_check_file_name(name)
      recipe do
        keepalived_tcp_check name do
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/TCP_CHECK\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        expect(chef_run).to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for connect_ip, connect_port and connect_timeout' do
      name = 'mysql-3306'
      file_name = tcp_check_file_name(name)
      recipe do
        keepalived_tcp_check name do
          connect_ip '192.168.1.1'
          connect_port 3306
          connect_timeout 5
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/TCP_CHECK\s+\{.*\}/m)
      end
      it('should render a config file with the connect_ip correctly') do
        is_expected.to render_file(file_name).with_content(/connect_ip\s192\.168\.1\.1/)
      end
      it('should render a config file with the connect_port correctly') do
        is_expected.to render_file(file_name).with_content(/connect_port\s3306/)
      end
      it('should render a config file with connect_timeout set correctly') do
        is_expected.to render_file(file_name).with_content(/connect_timeout\s5/)
      end
    end

    context 'When given inputs for bind_to, bind_port, warmup and fwmark' do
      name = 'webserver-443'
      file_name = tcp_check_file_name(name)
      recipe do
        keepalived_tcp_check name do
          bind_to '192.168.1.2'
          bind_port 443
          fwmark 3
          warmup 2
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/TCP_CHECK\s+\{.*\}/m)
      end
      it('should render a config file with the bind_to correctly') do
        is_expected.to render_file(file_name).with_content(/bindto\s192\.168\.1\.2/)
      end
      it('should render a config file with the bind_port correctly') do
        is_expected.to render_file(file_name).with_content(/bind_port\s443/)
      end
      it('should render a config file with fwmark set correctly') do
        is_expected.to render_file(file_name).with_content(/fwmark\s3/)
      end
      it('should render a config file with warmup set correctly') do
        is_expected.to render_file(file_name).with_content(/warmup\s2/)
      end
    end
  end
end
