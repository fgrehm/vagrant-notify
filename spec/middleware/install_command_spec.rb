describe Vagrant::Notify::Middleware::InstallCommand do
  let(:start_stack)           { Vagrant.actions[:start].send(:stack) }
  let(:host_ip)               { 'host-ip' }
  let(:host_port)             { '8081' }
  let(:template)              { ERB.new('<%= host_ip %> <%= host_port %>') }
  let(:compiled_command_path) { @env[:vm].env.tmp_path + 'vagrant-notify-send' }
  let(:target_tmp_path)       { '/tmp/notify-send' }
  let(:target_path)           { '/usr/bin/notify-send' }
  let(:channel)               { mock(:channel, :sudo => true, :upload => true) }
  let(:get_ip_command)        { 'echo -n $SSH_CLIENT | cut -d" " -f1' }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
    @env[:vm].stub(:channel => channel)
    ERB.stub(:new => template)
  end

  it 'gets called before provision middleware when starting machine' do
    provision_index  = start_stack.index([Vagrant::Action::VM::Provision, [], nil])
    middleware_index = start_stack.index([described_class, [], nil])

    provision_index.should > middleware_index
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
end
