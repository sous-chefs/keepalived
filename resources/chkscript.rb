#
# Cookbook Name:: keepalived
# Resource:: chkscript
#

actions :create

default_action :create

# Covers 0.10.8 and earlier
def initialize(*args)
  super
  @action = :create
end

attribute :script, :kind_of => String, :required => true
attribute :interval, :kind_of => Integer, :default => 5
attribute :weight, :kind_of => Integer, :default => -2
attribute :rise, :kind_of => Integer, :default => 2
attribute :fall, :kind_of => Integer, :default => 2
