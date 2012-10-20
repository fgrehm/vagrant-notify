describe Vagrant::Notify::Middleware do
  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
  end

  it 'prints a hello world message when called' do
    @env[:ui].should_receive(:info).with("Hello from 'default'!")
    subject.call(@env)
  end
end
