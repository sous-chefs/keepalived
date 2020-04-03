require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

static_ipaddress_config_file = '/etc/keepalived/conf.d/static_ipaddress.conf'

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_static_ipaddress on #{platform}" do
    step_into :keepalived_static_ipaddress
    platform platform

    context 'Create a base config correctly' do
      recipe do
        keepalived_static_ipaddress 'static_ipaddress' do
          addresses [
            'foo',
          ]
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(static_ipaddress_config_file).with_content(/static_ipaddress\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        expect(chef_run).to create_template(static_ipaddress_config_file).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'Create a config file with defined ip addresses' do
      recipe do
        keepalived_static_ipaddress 'static_ipaddress' do
          addresses [
            '192.168.1.98/24 dev eth0 scope global',
            '192.168.1.99/24 dev eth0 scope global',
          ]
        end
      end

      describe 'should render config file with the ip addresses' do
        it {
          is_expected.to render_file(static_ipaddress_config_file)
            .with_content(%r{192\.168\.1\.98/24 dev eth0 scope global})
            .with_content(%r{192\.168\.1\.99/24 dev eth0 scope global})
        }
      end
    end
  end
end
