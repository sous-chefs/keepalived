require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

static_routes_config_file = '/etc/keepalived/conf.d/static_routes.conf'

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_static_routes on #{platform}" do
    step_into :keepalived_static_routes
    platform platform

    context 'Create a base config correctly' do
      cached(:subject) { chef_run }
      recipe do
        keepalived_static_routes 'static_routes' do
          routes [
            'foo',
          ]
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(static_routes_config_file).with_content(/static_routes\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(static_routes_config_file).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'Create a config file with defined routes' do
      cached(:subject) { chef_run }
      recipe do
        keepalived_static_routes 'static_routes' do
          routes [
            '192.168.2.0/24 via 192.168.1.100 dev eth0',
            '192.168.3.0/24 via 192.168.1.100 dev eth0',
          ]
        end
      end

      describe 'should render config file with the routes' do
        it {
          is_expected.to render_file(static_routes_config_file)
            .with_content(%r{192\.168\.2\.0/24 via 192\.168\.1\.100 dev eth0})
            .with_content(%r{192\.168\.3\.0/24 via 192\.168\.1\.100 dev eth0})
        }
      end
    end
  end
end
