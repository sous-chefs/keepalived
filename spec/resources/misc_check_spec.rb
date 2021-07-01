require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def misc_check_file_name(name)
  "/etc/keepalived/checks.d/keepalived_misc_check__#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_misc_check on #{platform}" do
    step_into :keepalived_misc_check
    platform platform

    context 'Create a base config correctly' do
      cached(:subject) { chef_run }
      name = 'example-80'
      file_name = misc_check_file_name(name)
      recipe do
        keepalived_misc_check name do
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/MISC_CHECK\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for misc_path, misc_timeout warmup and misc_dynamic' do
      cached(:subject) { chef_run }
      name = 'mysql-3306'
      file_name = misc_check_file_name(name)
      recipe do
        keepalived_misc_check name do
          misc_path '/opt/checks/misc/mysql.sh'
          misc_timeout 5
          warmup 10
          misc_dynamic true
        end
      end

      it('should render a config file') do
        is_expected.to render_file(file_name).with_content(/MISC_CHECK\s+\{.*\}/m)
      end
      it('should render a config file with the misc_path correctly') do
        is_expected.to render_file(file_name).with_content(%r{misc_path\s/opt/checks/misc/mysql\.sh})
      end
      it('should render a config file with the misc_timeout correctly') do
        is_expected.to render_file(file_name).with_content(/misc_timeout\s5/)
      end
      it('should render a config file with warmup set correctly') do
        is_expected.to render_file(file_name).with_content(/warmup\s10/)
      end
      it('should render a config file with the misc_dynamic correctly') do
        is_expected.to render_file(file_name).with_content(/misc_dynamic/)
      end
    end
  end
end
