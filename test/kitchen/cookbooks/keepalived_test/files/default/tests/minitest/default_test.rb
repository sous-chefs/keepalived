require_relative './helpers.rb'

describe_recipe 'keepalived_test::default' do

  include KeepalivedHelpers

  describe 'keepalived' do

    it 'should create a keepalived configuration file' do
      file('/etc/keepalived/keepalived.conf').must_exist
    end

    it 'should start keepalived daemon' do
      service('keepalived').must_be_enabled
      service('keepalived').must_be_running
    end

  end
end
