require 'spec_helper'

describe service("keepalived") do
  it { should be_enabled }
end

describe file("/etc/keepalived/conf.d/vs_myserver.conf") do
  it { should be_file }
  it { should contain 'virtual_server 127.0.0.1 8080' }
  it { should contain  "delay_loop 10" }
  it { should contain  "lb_algo rr" }
  it { should contain  "lb_kind NAT" }
  it { should contain  "protocol TCP" }
  it { should contain  "real_server 10.10.10.10 8000" }
  it { should contain  "real_server 10.10.10.11 8101" }
  it { should contain  "HTTP_GET" }
  it { should contain  "status_code 200" }
end

describe file("/etc/keepalived/conf.d/vrrp_MYSERVER.conf") do
  it { should be_file }
  it { should contain "vrrp_instance MYSERVER" }
  it { should contain "interface management" }
  it { should contain "virtual_router_id 1" }
  it { should contain "state MASTER" }
  it { should contain "priority 10" }
  it { should contain "nopreempt" }
  it { should contain "advert_int 5" }
  it { should contain "auth_type PASS" }
  it { should contain "auth_pass authpass" }
  it { should contain "10.10.10.10" }
  it { should contain "track_script" }
  it { should contain 'notify_master "master"' }
  it { should contain 'notify_backup "backup"' }
  it { should contain 'notify_fault "fault"' }
end
