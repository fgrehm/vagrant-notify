describe Vagrant::Notify::Server do
  it 'runs notify-send with received data' do
    subject.should_receive(:system).with('notify-send args')
    subject.receive_data('args')
  end
end
