describe Vagrant::Notify::Server do
  subject { described_class.new('sig') }

  it 'runs notify-send with received data' do
    subject.should_receive(:system).with('notify-send args')
    subject.receive_data('args')
  end
end
