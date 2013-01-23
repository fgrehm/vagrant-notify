describe Vagrant::Notify::Server do
  let(:arguments) { "-- '20 examples, 1 failure\n10 seconds'" }
  let(:client)    { StringIO.new(arguments) }

  subject { described_class.new('uuid') }

  before do
    subject.stub(:system => true)
  end

  it 'runs notify-send with received data from client' do
    subject.should_receive(:system).with("notify-send #{arguments}")
    subject.receive_data(client)
  end

  it 'closes connection after reading data' do
    client.should_receive(:close)
    subject.receive_data(client)
  end
end
