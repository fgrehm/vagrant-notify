require 'spec_helper'

require 'fileutils'
require 'tmpdir'

require 'vagrant-notify/action/prepare_data'

describe Vagrant::Notify::Action::PrepareData do
  let(:data_dir) { Pathname.new(Dir.mktmpdir) }
  let(:app)      { lambda { |env| } }
  let(:env)      { {machine: mock(data_dir: data_dir)} }

  subject { described_class.new(app, env) }

  before { subject.call(env) }
  after  { FileUtils.rm_rf data_dir.to_s }

  it 'creates the directory to keep vagrant notify data' do
    data_dir.join('vagrant-notify').should be_directory
  end

  it 'assigns a data object to the environment' do
    env[:notify_data].should be_a(Vagrant::Notify::Data)
  end
end
