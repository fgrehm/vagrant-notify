require 'spec_helper'

require 'vagrant-notify/action/start_server'

require 'vagrant-notify/server'

describe Vagrant::Notify::Action::StartServer do
  let(:app)        { lambda { |env| } }
  let(:ui)         { mock(success: true)}
  let(:id)         { '425e799c-1293-4939-bo39-263lcc7457e8' }
  let(:machine)    { mock(state: stub(id: :stopped), ui: ui, id: id) }
  let(:env)        { {notify_data: {}, machine: machine} }
  let(:pid)        { '42' }
  let(:port)       { '1234' }

  subject { described_class.new(app, env) }

  before do
    Vagrant::Notify::Server.stub(:run => pid)
    subject.stub(next_available_port: port)
    subject.call(env)
  end

  after do
    Process.kill('KILL', env[:notify_data][:pid].to_i)
  end

  it 'starts the server and persists used port' do
    env[:notify_data][:port].should == port
  end

  # need proper test of this
  # it "removes server PID from notify data" do
  #  env[:notify_data][:pid].should be_nil
  # end

  pending 'identifies the next available port'
end