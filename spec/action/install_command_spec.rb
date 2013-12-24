require 'spec_helper'

require 'vagrant-notify'
require 'vagrant-notify/action/install_command'

describe Vagrant::Notify::Action::InstallCommand do
  let(:app)              { lambda { |env| } }
  let(:env)              { {notify_data: {port: host_port}, machine: machine, tmp_path: tmp_path} }
  let(:host_port)        { 12345 }
  let(:machine)          { mock(communicate: communicator) }
  let(:communicator)     { mock(upload: true, sudo: true) }
  let(:host_ip)          { '192.168.1.2' }
  let(:tmp_path)         { Pathname.new(Dir.mktmpdir) }
  let(:tmp_cmd_path)     { tmp_path.join('vagrant-notify-send') }
  let(:guest_tmp_path)   { '/tmp/notify-send' }
  let(:guest_path)       { '/usr/bin/notify-send' }
  let(:stubbed_template) { ERB.new('<%= host_port %>') }

  subject { described_class.new(app, env) }

  before do
    ERB.stub(:new => stubbed_template)
    subject.call(env)
  end

  after { FileUtils.rm_rf tmp_path.to_s }

  it 'compiles command script passing server port' do
    tmp_cmd_path.read.should == "#{host_port}"
  end

  it 'uploads compiled command script over to guest machine' do
    communicator.should have_received(:upload).with(tmp_cmd_path.to_s, guest_tmp_path)
  end

  it 'creates a backup for the available command' do
    communicator.should have_received(:sudo).with("mv /usr/bin/{notify-send,notify-send.bkp}; exit 0")
  end

  it 'installs command for all users' do
    communicator.should have_received(:sudo).with("mv #{guest_tmp_path} #{guest_path} && chmod +x #{guest_path}")
  end
end
