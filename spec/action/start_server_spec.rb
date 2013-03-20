require 'spec_helper'

require 'vagrant-notify/action/start_server'

describe Vagrant::Notify::Action::StartServer do
  let(:app)  { lambda { |env| } }
  let(:env)  { {notify_data: {}} }
  let(:pid)  { '42' }
  let(:port) { described_class::PORT }

  subject { described_class.new(app, env) }

  before do
    Vagrant::Notify::Server.stub(:run => pid)
    subject.call(env)
  end

  it 'starts the server' do
    Vagrant::Notify::Server.should have_received(:run).with(env, port)
  end

  it 'persists pid number' do
    env[:notify_data][:pid].should == pid
  end

  it 'persists used port' do
    env[:notify_data][:port].should == port
  end
end
