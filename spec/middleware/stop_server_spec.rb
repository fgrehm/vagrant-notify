describe Vagrant::Notify::Middleware::StopServer do
  let(:halt_stack)    { Vagrant.actions[:halt].send(:stack) }
  let(:suspend_stack) { Vagrant.actions[:halt].send(:stack) }
  let(:server_pid)    { '1234' }
  let(:local_data)    { { 'vagrant-notify' => { 'pid' => server_pid } } }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    @env[:vm].env.stub(:local_data => local_data)
    local_data.stub(:commit)
  end

  it 'gets called when halting machine' do
    halt_stack.should include([described_class, [], nil])
  end

  it 'gets called when suspending machine' do
    suspend_stack.should include([described_class, [], nil])
  end

  context 'server is down' do
    before { Process.stub(:getpgid).and_raise(Errno::ESRCH) }

    it 'does not notify user about server stop' do
      @env[:ui].should_not_receive(:info)
      subject.call(@env)
    end
  end

  context 'server is up' do
    before do
      Process.stub(:getpgid => true)
      local_data['vagrant-notify'] = { 'pid' => server_pid }
    end

    it 'notifies user that server is stopping' do
      @env[:ui].should_receive(:info).with('Stopping notification server...')
      subject.call(@env)
    end

    it 'kills notification server' do
      Process.should_receive(:kill).with('KILL', server_pid.to_i)
      subject.call(@env)
    end

    it "removes server PID on local data" do
      local_data.should_receive(:commit)
      subject.call(@env)
      local_data['vagrant-notify']['pid'].should be_nil
    end
  end
end
