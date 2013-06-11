#
# Cookbook Name:: keepalived_test
# Recipe:: default
#

require_relative "./support/helpers"

describe_recipe "keepalived_test::default" do

  include KeepalivedTestHelpers

  describe "keepalived" do

    it "should create a keepalived configuration file" do
      file("/etc/keepalived/keepalived.conf").must_exist
    end

    it "should start keepalived daemon" do
      service("keepalived").must_be_enabled
      service("keepalived").must_be_running
    end

  end
end
