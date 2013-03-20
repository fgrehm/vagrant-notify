require 'spec_helper'

require 'vagrant-notify/data'

describe Vagrant::Notify::Data do
  let!(:data_dir) { Pathname.new(Dir.mktmpdir) }
  let(:key)       { :pid }
  let(:value)     { '123456' }

  subject { described_class.new(data_dir) }

  after { FileUtils.rm_rf data_dir.to_s }

  it 'writes data out to a file' do
    subject[key] = value

    data_dir.join(key.to_s).read.should eq value
  end

  it 'reads data from files' do
    data_dir.join(key.to_s).open('w+') { |f| f.write(value) }

    subject[key].should eq value
  end

  it 'handles unset keys' do
    subject[key].should be_nil
  end
end
