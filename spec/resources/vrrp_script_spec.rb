require 'spec_helper'

# see documentation here: https://www.keepalived.org/manpage.html

def vrrp_script_file_name(name)
  "/etc/keepalived/conf.d/00_keepalived_vrrp_script__#{name}__.conf"
end

platforms = %w(debian ubuntu centos)
platforms.each do |platform|
  describe "keepalived_vrrp_script on #{platform}" do
    step_into :keepalived_vrrp_script
    platform platform

    context 'Create a base config correctly' do
      cached(:subject) { chef_run }
      script_name = 'foobar'
      file_name = vrrp_script_file_name(script_name)
      recipe do
        keepalived_vrrp_script script_name do
          script script_name
        end
      end

      it('should render an empty config file') do
        is_expected.to render_file(file_name).with_content(/#{script_name}\s+\{.*\}/m)
      end

      it 'creates the config file with the owner, group and mode' do
        is_expected.to create_template(file_name).with(
            owner: 'root',
            group: 'root',
            mode: '0640'
          )
      end
    end

    context 'When given inputs for interval, weight and script' do
      cached(:subject) { chef_run }
      script_name = 'chk_haproxy'
      file_name = vrrp_script_file_name(script_name)
      recipe do
        keepalived_vrrp_script script_name do
          script '/usr/local/bin/chk-haproxy.sh'
          interval 2
          weight 50
        end
      end

      it('should render a config file with the script correctly') do
        is_expected.to render_file(file_name).with_content(%r{script\s/usr/local/bin/chk-haproxy\.sh})
      end
      it('should render a config file with the interval correctly') do
        is_expected.to render_file(file_name).with_content(/interval\s2/)
      end
      it('should render a config file with the weight correctly') do
        is_expected.to render_file(file_name).with_content(/weight\s50/)
      end
    end

    context 'When given inputs for timeout, fall, rise and user' do
      cached(:subject) { chef_run }
      script_name = 'chk_haproxy'
      file_name = vrrp_script_file_name(script_name)
      recipe do
        keepalived_vrrp_script script_name do
          script '/usr/local/bin/chk-haproxy.sh'
          timeout 10
          fall 20
          rise 30
          user 'scriptUser'
        end
      end

      it('should render a config file with the script correctly') do
        is_expected.to render_file(file_name).with_content(%r{script\s/usr/local/bin/chk-haproxy\.sh})
      end
      it('should render a config file with the timeout correctly') do
        is_expected.to render_file(file_name).with_content(/timeout\s10/)
      end
      it('should render a config file with the fall correctly') do
        is_expected.to render_file(file_name).with_content(/fall\s20/)
      end
      it('should render a config file with the rise correctly') do
        is_expected.to render_file(file_name).with_content(/rise\s30/)
      end
      it('should render a config file with the user correctly') do
        is_expected.to render_file(file_name).with_content(/user\sscriptUser/)
      end
    end
  end
end
