require 'spec_helper'

require 'vagrant-notify/action/stop_server'

describe Vagrant::Notify::Action::StopServer do
  let(:app)          { lambda { |env| } }
  let(:config)       { double(notify: double(enable: true)) }
  let(:communicator) { double(sudo: true) }
  let(:ui)           { double(success: true) }
  let(:machine)      { double(communicate: communicator, state: double(id: :running), ui: ui, config: config) }
  let(:env)          { {notify_data: {pid: pid, port: 1234}, machine: machine} }
  let(:pid)          { '42' }
  let(:port)         { described_class::PORT }

  subject { described_class.new(app, env) }

  before do
    Process.stub(kill: true)
    subject.call(env)
  end

  it 'kills the notification server' do
    Process.should have_received(:kill).with('KILL', pid.to_i).at_most(2).times
  end

  it "removes server PID from notify data" do
    env[:notify_data][:pid].should be_nil
  end

  it "removes server port from notify data" do
    env[:notify_data][:port].should be_nil
  end
end
