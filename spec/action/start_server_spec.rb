require 'spec_helper'

require 'vagrant-notify/action/start_server'

require 'vagrant-notify/server'

describe Vagrant::Notify::Action::StartServer do
  let(:app)           { lambda { |env| } }
  let(:sender_params_str) { "[--app-name {app_name}] [--urgency {urgency}] [--expire-time {expire_time}] [--icon {icon}] [--category {category}] [--hint {hint}] {message}"}
  let(:config)        { double(notify: double(enable: true, sender_app: 'notify-send', sender_params_str: sender_params_str, sender_params_escape: false)) }
  let(:ui)            { double(success: true)}
  let(:id)            { '425e799c-1293-4939-bo39-263lcc7457e8' }
  let(:provider_name) { 'virtualbox' }
  let(:machine)       { double(state: double(id: :stopped), ui: ui, id: id, config: config,  provider_name: provider_name) }
  let(:env)           { {notify_data: {bind_ip: "127.0.0.1"}, machine: machine} }
  let(:pid)           { '42' }
  let(:port)          { '1234' }

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

  #pending 'identifies the next available port'
end
