describe Vagrant::Notify::Middleware do
  let(:start_stack) { Vagrant.actions[:start].send(:stack) }
  let(:server_pid)  { 1234 }
  let(:local_data)  { Hash.new }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    @env[:vm].env.stub(:local_data => local_data)
    local_data.stub(:commit)
    Vagrant::Notify::Server.stub(:run => server_pid)
  end

  it 'gets called before provision middleware when starting machine' do
    provision_index  = start_stack.index([Vagrant::Action::VM::Provision, [], nil])
    middleware_index = start_stack.index([Vagrant::Notify::Middleware, [], nil])

    provision_index.should > middleware_index
  end

  context 'server is down' do
    before { Process.stub(:getpgid).and_raise(Errno::ESRCH) }

    it 'fires up notification server when called' do
      Vagrant::Notify::Server.should_receive(:run)
      subject.call(@env)
    end

    it 'notifies user about server start' do
      @env[:ui].should_receive(:info).with("Notification server fired up (#{server_pid})")
      subject.call(@env)
    end

    it "persists server PID on local data" do
      local_data.should_receive(:commit)
      subject.call(@env)
      local_data['vagrant-notify']['pid'].should == server_pid
    end

    context "and a PID is present on Vagrant's local data" do
      let(:new_pid) { server_pid + 1 }

      before do
        Vagrant::Notify::Server.stub(:run => new_pid)
        local_data['vagrant-notify'] = { 'pid' => server_pid }
      end

      it 'updates server PID' do
        subject.call(@env)
        local_data['vagrant-notify']['pid'].should == new_pid
      end
    end
  end

  context 'server is up' do
    before do
      Process.stub(:getpgid => true)
      local_data['vagrant-notify'] = { 'pid' => server_pid }
    end

    it 'does not start a new server instance' do
      Vagrant::Notify::Server.should_not_receive(:run)
      subject.call(@env)
    end

    it 'notifies user that server is already running' do
      @env[:ui].should_receive(:info).with("Notification server is already running (#{server_pid})")
      subject.call(@env)
    end
  end
end
