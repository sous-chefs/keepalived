#
# Cookbook Name:: keepalived_test
# Recipe:: default
#

require "chef/mixin/shell_out"
module KeepalivedTestHelpers
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
end
