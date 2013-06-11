require "spec_helper"

describe "keepalived:default" do
  let(:chef_run) { runner.converge "keepalived_test::default" }
  let(:node) { runner.node }
  let(:platform) { { :platform => "ubuntu", :version => "12.04" } }
  let(:results) { [] }
  let(:runner) { ChefSpec::ChefRunner.new(runner_options) }
  let(:runner_options) do
    {
      :cookbook_path => [COOKBOOK_PATH],
      :evaluate_guards => true,
      :step_into => step_into
    }.merge(platform)
  end
  let(:step_into) { [] }

  before { node.set["lsb"]["codename"] = "ChefSpec" }

  describe "keepalived_test::virtual_server_provider_create" do
    let(:chef_run) do
      runner.converge "keepalived_test::virtual_server_provider_create"
    end
    let(:step_into) { ["keepalived_virtual_server"] }
    let(:file) { "/etc/keepalived/conf.d/vs_myserver.conf" }
    let(:name) { "vs_myserver" }


    it "creates a virtual server file in conf.d" do
      chef_run.should create_file(file)
      chef_run.should create_file_with_content name, "virtual_server 127.0.0.1 8080"
      chef_run.should create_file_with_content name, "delay_loop 10"
      chef_run.should create_file_with_content name, "lb_algo rr"
      chef_run.should create_file_with_content name, "lb_kind NAT"
      chef_run.should create_file_with_content name, "protocol TCP"
      chef_run.should create_file_with_content name, "real_server 10.10.10.10 8000"
      chef_run.should create_file_with_content name, "real_server 10.10.10.11 8101"
    end
  end

  describe "keepalived_test::vrrp_provider_create" do
    let(:chef_run) do
      runner.converge "keepalived_test::vrrp_provider_create"
    end
    let(:step_into) { ["keepalived_vrrp"] }
    let(:file) { "/etc/keepalived/conf.d/vrrp_MYSERVER.conf" }
    let(:name) { "vrrp_MYSERVER" }


    it "creates a vrrp file in conf.d" do
      chef_run.should create_file(file)
      chef_run.should create_file_with_content name, "vrrp_instance MYSERVER"
      chef_run.should create_file_with_content name, "interface management"
      chef_run.should create_file_with_content name, "virtual_router_id 1"
      chef_run.should create_file_with_content name, "state MASTER"
      chef_run.should create_file_with_content name, "priority 10"
      chef_run.should create_file_with_content name, "nopreempt"
      chef_run.should create_file_with_content name, "advert_int 5"
      chef_run.should create_file_with_content name, "auth_type PASS"
      chef_run.should create_file_with_content name, "auth_pass authpass"
      chef_run.should create_file_with_content name, /virtual_ipaddress\s+{\s+10.10.10.10/
      chef_run.should create_file_with_content name, /track_script\s+{\s+track_script/
      chef_run.should create_file_with_content name, 'notify_master "master"'
      chef_run.should create_file_with_content name, 'notify_backup "backup"'
      chef_run.should create_file_with_content name, 'notify_fault "fault"'
    end
  end

  describe "keepalived_test::chkscript_provider_create" do
    let(:chef_run) do
      runner.converge "keepalived_test::chkscript_provider_create"
    end
    let(:step_into) { ["keepalived_chkscript"] }
    let(:file) { "/etc/keepalived/conf.d/script_myserver.conf" }
    let(:name) { "myserver" }


    it "creates a chkscript file in conf.d" do
      chef_run.should create_file(file)
      chef_run.should create_file_with_content name, "vrrp_script myserver"
      chef_run.should create_file_with_content name, 'script "myscript.py"'
      chef_run.should create_file_with_content name, "interval 10"
      chef_run.should create_file_with_content name, "weight 9"
      chef_run.should create_file_with_content name, "rise 8"
      chef_run.should create_file_with_content name, "fall 7"
    end
  end

end
