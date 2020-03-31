require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def virtual_server_group_file_name(name)
  "/etc/keepalived/conf.d/keepalived_virtual_server_group__#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_virtual_server_group on #{platform}" do
    step_into :keepalived_virtual_server_group
    platform platform

    context 'Create a base config correctly' do
      name = 'servers'
      file_name = virtual_server_group_file_name(name)
      recipe do
        keepalived_virtual_server_group name do
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server_group servers\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        expect(chef_run).to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for vips, and fwmarks' do
      name = 'webservers'
      vips = ['192.168.1.1 80', '192.168.1.2 80']
      fwmarks = [ 1, 2 ]
      file_name = virtual_server_group_file_name(name)
      recipe do
        keepalived_virtual_server_group name do
          vips vips
          fwmarks fwmarks
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/virtual_server_group webservers\s+\{.*\}/m)
      end
      it('should render a config file with the vips correctly') do
        is_expected.to render_file(file_name).with_content(/192\.168\.1\.1\s80/)
        is_expected.to render_file(file_name).with_content(/192\.168\.1\.2\s80/)
      end
      it('should render a config file with the fwmarks correctly') do
        is_expected.to render_file(file_name).with_content(/fwmark\s1/)
        is_expected.to render_file(file_name).with_content(/fwmark\s2/)
      end
    end
  end
end
