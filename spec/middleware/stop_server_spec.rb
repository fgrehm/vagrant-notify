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

  it 'gets called when halting machine' do
    halt_stack.should include([described_class, [], nil])
  end

  it 'kills notification server' do
    Process.should_receive(:kill).with('KILL', server_pid.to_i)
    subject.call(@env)
  end

  it 'notifies user that server is stopping' do
    @env[:ui].should_receive(:info).with('Stopping notification server')
    subject.call(@env)
  end
end
