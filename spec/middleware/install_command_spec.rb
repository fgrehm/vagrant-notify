describe Vagrant::Notify::Middleware::InstallCommand do
  let(:start_stack) { Vagrant.actions[:start].send(:stack) }

  subject { described_class.new(@app, @env) }

  before do
    @app, @env = action_env(vagrant_env.vms.values.first.env)
  end

  it 'gets called before provision middleware when starting machine' do
    provision_index  = start_stack.index([Vagrant::Action::VM::Provision, [], nil])
    middleware_index = start_stack.index([described_class, [], nil])

    provision_index.should > middleware_index
  end
end
