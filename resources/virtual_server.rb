#
# Cookbook Name:: keepalived
# Resource:: virtual_server
#

actions :create

default_action :create

# Covers 0.10.8 and earlier
def initialize(*args)
  super
  @action = :create
end

attribute :vs_listen_ip, :kind_of => String, :required => true
attribute :vs_listen_port, :kind_of => String, :required => true
attribute :delay_loop, :kind_of => Integer, :default => 15
attribute :lb_algo, :kind_of => String, :equal_to => ["rr", "wrr", "lc", "wlc", "sh", "dh", "lblc"], :default => "rr"
attribute :lb_kind, :kind_of => String, :equal_to => ["nat", "dr", "tun"], :default => "nat"
attribute :vs_protocol, :kind_of => String, :equal_to => ["tcp", "udp"], :default => "tcp"
attribute :real_servers, :kind_of => Array, :required => true
