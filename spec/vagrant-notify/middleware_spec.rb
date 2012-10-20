describe Vagrant::Notify::Middleware do
  let(:start_stack) { Vagrant.actions[:start].send(:stack) }
  let(:server_pid)  { 1234 }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    Vagrant::Notify::Server.stub(:run => server_pid)
  end

  it 'gets called before provision middleware when starting machine' do
    provision_index  = start_stack.index([Vagrant::Action::VM::Provision, [], nil])
    middleware_index = start_stack.index([Vagrant::Notify::Middleware, [], nil])

    provision_index.should > middleware_index
  end

  it 'fires up notification server when called' do
    Vagrant::Notify::Server.should_receive(:run)
    subject.call(@env)
  end

  it 'notifies user about server start' do
    @env[:ui].should_receive(:info).with("Notification server fired up (#{server_pid})")
    subject.call(@env)
  end
end
