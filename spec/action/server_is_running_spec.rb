require 'spec_helper'

require 'vagrant-notify/action/server_is_running'

describe Vagrant::Notify::Action::ServerIsRunning do
  let(:app) { lambda { |env| } }
  let(:env) { {notify_data: {pid: pid, bind_ip: "127.0.0.1"}} }

  subject { described_class.new(app, env) }

  context 'when pid is not set' do
    let(:pid) { nil }

    it 'sets the result to false' do
      env[:result].should be_false
    end
  end

  context 'when pid is set' do
    let(:pid) { '12345' }

    context 'and is valid' do
      before do
        Process.stub(:getpgid => true)
        subject.call(env)
      end

      it 'sets the result to true' do
        env[:result].should be_true
      end
    end

    context 'and is invalid' do
      before do
        Process.stub(:getpgid).and_raise(Errno::ESRCH)
        subject.call(env)
      end

      it 'sets the result to false' do
        env[:result].should be_false
      end
    end
  end
end
