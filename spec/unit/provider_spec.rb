require 'spec_helper'

describe ChefKeepalived::Provider::Config do
  let(:node) { Chef::Node.new }
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:current_resource) { ChefKeepalived::Resource::Config.new('dummy') }
  let(:path) { '/etc/keepalived/conf.d/keepalived_config__dummy__.conf' }
  let(:content) { 'linkbeat_use_polling' }
  let(:new_resource) { ChefKeepalived::Resource::Config.new('dummy') }
  let(:provider) { ChefKeepalived::Provider::Config.new(new_resource, run_context) }

  before(:each) do
    allow(ChefKeepalived::Resource::Config).to receive(:new)
      .with('dummy')
      .and_return(current_resource)
  end

  describe 'load current resource' do
    before(:each) do
      allow(File).to receive(:exist?).with(path).and_return(false)
    end

    it 'checks for file existence' do
      expect(File).to receive(:exist?).with(path)
      provider.load_current_resource
    end

    it 'does not load if not exist' do
      expect(File).to_not receive(:read)
      provider.load_current_resource
      expect(current_resource.content).to eq ''
    end

    it 'loads the file content if it exists' do
      allow(File).to receive(:exist?).with(path).and_return(true)
      allow(File).to receive(:read).with(path).and_return(content)
      expect(File).to receive(:read).with(path)
      provider.load_current_resource
      expect(current_resource.content).to eq content
    end
  end

  describe '#action_create' do
    before(:each) do
      provider.current_resource = current_resource
      new_resource.content(content)
    end

    it 'creates the file when it does not exist' do
      allow(File).to receive(:exist?).with(path).and_return(false)
      allow(provider).to receive(:manage_config_file).with(:create)
      expect(provider).to receive(:manage_config_file).with(:create)
      provider.action_create
    end

    it 'creates the file when it exists and the content is different' do
      allow(File).to receive(:exist?).with(path).and_return(true)
      allow(File).to receive(:read).with(path).and_return('derp')
      allow(provider).to receive(:manage_config_file).with(:create)
      expect(provider).to receive(:manage_config_file).with(:create)
      provider.action_create
    end

    it 'does not create the file when it exists and the content is the same' do
      current_resource.exists(true)
      current_resource.content(content)
      allow(provider).to receive(:manage_config_file)
      expect(provider).to_not receive(:manage_config_file)
      provider.action_create
    end
  end

  describe '#action_delete' do
    before(:each) { provider.current_resource = current_resource }

    it 'deletes the file when it exists' do
      current_resource.exists(true)
      allow(provider).to receive(:manage_config_file).with(:delete)
      expect(provider).to receive(:manage_config_file).with(:delete)
      provider.action_delete
    end

    it 'does not delete the file when it does not exist' do
      current_resource.exists(false)
      allow(provider).to receive(:manage_config_file)
      expect(provider).to_not receive(:manage_config_file)
      provider.action_delete
    end
  end
end
