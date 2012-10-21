describe Vagrant::Notify::Middleware::StopServer do
  let(:halt_stack) { Vagrant.actions[:halt].send(:stack) }
  let(:server_pid) { '1234' }
  let(:local_data) { { 'vagrant-notify' => { 'pid' => server_pid } } }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    @env[:vm].env.stub(:local_data => local_data)
    local_data.stub(:commit)
  end

  it 'gets called before halt middleware when halting machine' do
    halt_index       = halt_stack.index([Vagrant::Action::VM::Halt, [], nil])
    middleware_index = halt_stack.index([described_class, [], nil])

    halt_index.should > middleware_index
  end

  it 'kills notification server' do
    Process.should_receive(:kill).with('KILL', server_pid.to_i)
    subject.call(@env)
  end
end
