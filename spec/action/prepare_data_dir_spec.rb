require 'spec_helper'

require 'fileutils'
require 'tmpdir'

require 'vagrant-notify/action/prepare_data_dir'

describe Vagrant::Notify::Action::PrepareDataDir do
  let(:data_dir) { Pathname.new(Dir.mktmpdir) }
  let(:app)      { lambda { |env| } }
  let(:env)      { {machine: mock(data_dir: data_dir)} }

  subject { described_class.new(app, env) }

  after { FileUtils.rm_rf data_dir.to_s }

  it 'creates the directory to keep vagrant notify data' do
    subject.call(env)
    data_dir.join('vagrant-notify').should be_directory
  end
end
