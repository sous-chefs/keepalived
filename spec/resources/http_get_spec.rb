require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def http_get_file_name(name)
  "/etc/keepalived/checks.d/keepalived_http_get__#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_http_get on #{platform}" do
    step_into :keepalived_http_get
    platform platform

    context 'Create a base config correctly' do
      cached(:subject) { chef_run }
      name = 'example-80'
      file_name = http_get_file_name(name)
      recipe do
        keepalived_http_get name do
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/HTTP_GET\s+\{.*\}/m)
      end

      it('should render a config file with default url') do
        is_expected.to render_file(file_name).with_content(%r{url\s+\{\s+path\s/\s+status_code\s200\s+\}}m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for URL and delay_before_retry' do
      cached(:subject) { chef_run }
      name = 'flask-3000'
      file_name = http_get_file_name(name)
      url_settings = { path: '/flask', digest: '123', status_code: 201 }
      recipe do
        keepalived_http_get name do
          delay_before_retry 5
          url url_settings
        end
      end

      it('should render a config file with the correct delay_before_retry settings') do
        is_expected.to render_file(file_name).with_content(/delay_before_retry\s5/)
      end

      it('should render a config file with the correct url settings') do
        is_expected.to render_file(file_name).with_content(%r{url\s+\{\s+path\s/flask\s+status_code\s201\s+digest\s123\s+\}}m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for connect_ip, connect_port and connect_timeout' do
      cached(:subject) { chef_run }
      name = 'mysql-3306'
      file_name = http_get_file_name(name)
      recipe do
        keepalived_http_get name do
          connect_ip '192.168.1.1'
          connect_port 3306
          connect_timeout 5
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/HTTP_GET\s+\{.*\}/m)
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
      cached(:subject) { chef_run }
      name = 'webserver-443'
      file_name = http_get_file_name(name)
      recipe do
        keepalived_http_get name do
          bind_to '192.168.1.2'
          bind_port 443
          fwmark 3
          warmup 2
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/HTTP_GET\s+\{.*\}/m)
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
