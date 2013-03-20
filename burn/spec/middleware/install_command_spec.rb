describe Vagrant::Notify::Middleware::InstallCommand do
  let(:start_stack)           { Vagrant.actions[:start].send(:stack) }
  let(:provision_stack)       { Vagrant.actions[:provision].send(:stack) }
  let(:resume_stack)          { Vagrant.actions[:resume].send(:stack) }
  let(:host_ip)               { 'host-ip' }
  let(:host_port)             { 789 }
  let(:template)              { ERB.new('<%= host_ip %> <%= host_port %>') }
  let(:compiled_command_path) { @env[:vm].env.tmp_path + 'vagrant-notify-send' }
  let(:target_tmp_path)       { '/tmp/notify-send' }
  let(:target_path)           { '/usr/bin/notify-send' }
  let(:channel)               { mock(:channel, :sudo => true, :upload => true, :execute => true) }
  let(:get_ip_command)        { 'echo -n $SSH_CLIENT | cut -d" " -f1' }
  let(:uuid)                  { @env[:vm].uuid.to_s }
  let(:local_data)            { Hash.new }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    @env[:vm].stub(:channel => channel)
    @env[:vm].env.stub(:local_data => local_data)
    local_data['vagrant-notify'] = { uuid => {'port' => host_port } }
    ERB.stub(:new => template)
  end

  it 'gets called after boot middleware when starting machine' do
    boot_index       = start_stack.index([Vagrant::Action::VM::Boot, [], nil])
    middleware_index = start_stack.index([described_class, [], nil])

    boot_index.should < middleware_index
  end

  it 'gets called when resuming machine' do
    resume_stack.should include([described_class, [], nil])
  end

  it 'gets called when provisioning machine' do
    provision_stack.should include([described_class, [], nil])
  end

  it "is able to identify host's ip" do
    channel.should_receive(:execute).with(get_ip_command).and_yield(:stdout, host_ip + "\n")
    subject.host_ip(@env).should == host_ip
  end

  it 'compiles command script passing host ip and server port' do
    subject.stub(:host_ip => host_ip)
    subject.call(@env)
    File.read(compiled_command_path).should == "#{host_ip} #{host_port}"
  end

  it 'uploads compiled command script over to guest machine' do
    channel.should_receive(:upload).with(compiled_command_path.to_s, target_tmp_path)
    subject.stub(:host_ip => host_ip)
    subject.call(@env)
  end

  it 'installs command for all users' do
    channel.should_receive(:sudo).with("mv #{target_tmp_path} #{target_path} && chmod +x #{target_path}")
    subject.stub(:host_ip => host_ip)
    subject.call(@env)
  end

  it 'notifies user about script installation' do
    @env[:ui].should_receive(:info).with('Compiling and installing notify-send script on guest machine')
    subject.call(@env)
  end
end
