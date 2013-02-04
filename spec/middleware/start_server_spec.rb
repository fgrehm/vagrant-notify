describe Vagrant::Notify::Middleware::StartServer do
  let(:start_stack)    { Vagrant.actions[:start].send(:stack) }
  let(:resume_stack)   { Vagrant.actions[:resume].send(:stack) }
  let(:server_pid)     { 1234 }
  let(:available_port) { 8080 }
  let(:uuid)           { @env[:vm].uuid.to_s }
  let(:local_data)     { Hash.new }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    @env[:vm].env.stub(:local_data => local_data)
    local_data.stub(:commit)
    Vagrant::Notify::Server.stub(:run => server_pid)
  end

  it 'gets called when starting machine' do
    start_stack.should include([described_class, [], nil])
  end

  it 'gets called when starting machine' do
    resume_stack.should include([described_class, [], nil])
  end

  context 'server is down' do
    before do
      Process.stub(:getpgid).and_raise(Errno::ESRCH)
      subject.stub(:next_available_port => available_port)
    end

    it 'fires up notification server when called' do
      Vagrant::Notify::Server.should_receive(:run).with(@env, available_port)
      subject.call(@env)
    end

    it 'notifies user about server start' do
      @env[:ui].should_receive(:info).with("Notification server is listening on #{available_port} (#{server_pid})")
      subject.call(@env)
    end

    it "persists server PID on local data" do
      local_data.should_receive(:commit)
      subject.call(@env)
      local_data['vagrant-notify'][uuid]['pid'].should == server_pid
    end

    it "persists server port on local data" do
      local_data.should_receive(:commit)
      subject.call(@env)
      local_data['vagrant-notify'][uuid]['port'].should == available_port
    end

    context "and a PID is present on Vagrant's local data" do
      let(:new_pid) { server_pid + 1 }

      before do
        Vagrant::Notify::Server.stub(:run => new_pid)
        local_data['vagrant-notify'] = { uuid => { 'pid' => server_pid } }
      end

      it 'updates server PID' do
        subject.call(@env)
        local_data['vagrant-notify'][uuid]['pid'].should == new_pid
      end
    end
  end

  context 'server is up' do
    before do
      Process.stub(:getpgid => true)
      local_data['vagrant-notify'] = { uuid => { 'pid' => server_pid } }
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
