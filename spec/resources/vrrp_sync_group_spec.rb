require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def vrrp_sync_group_file_name(name)
  "/etc/keepalived/conf.d/keepalived_vrrp_sync_group__#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_vrrp_sync_group on #{platform}" do
    step_into :keepalived_vrrp_sync_group
    platform platform

    context 'Create a base config correctly' do
      group_name = 'foobar'
      file_name = vrrp_sync_group_file_name(group_name)
      recipe do
        keepalived_vrrp_sync_group group_name do
          group %w(foo)
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/#{group_name}\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        expect(chef_run).to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'Create groups and smtp settings correctly' do
      group_name = 'foobar'
      file_name = vrrp_sync_group_file_name(group_name)
      recipe do
        keepalived_vrrp_sync_group group_name do
          group %w(inside_network outside_network)
          smtp_alert true
        end
      end

      it('should render a config file with the groups correctly') do
        is_expected.to render_file(file_name).with_content(/group\s\{\s+inside_network\s+outside_network\s+\}/m)
      end

      it('should render a config file with the smtp_alert set to true') do
        is_expected.to render_file(file_name).with_content(/smtp_alert\strue/)
      end
    end

    context 'Create notifies correctly' do
      group_name = 'foobar'
      file_name = vrrp_sync_group_file_name(group_name)
      recipe do
        keepalived_vrrp_sync_group group_name do
          group %w(foo)
          notify_master '/path/to_master.sh'
          notify_backup '/path/to_backup.sh'
          notify_fault  '/path/fault.sh'
          notify        '/path/notify.sh'
        end
      end

      it('should render a config file with the notify_master correctly') do
        is_expected.to render_file(file_name).with_content(%r{notify_master\s/path/to_master\.sh})
      end

      it('should render a config file with the notify_backup correctly') do
        is_expected.to render_file(file_name).with_content(%r{notify_backup\s/path/to_backup\.sh})
      end

      it('should render a config file with the notify_fault correctly') do
        is_expected.to render_file(file_name).with_content(%r{notify_fault\s/path/fault\.sh})
      end

      it('should render a config file with the notify correctly') do
        is_expected.to render_file(file_name).with_content(%r{notify\s/path/notify\.sh})
      end
    end
  end
end
