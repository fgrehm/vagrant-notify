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

  context 'incoming HTTP connections' do
    let(:client) do
      StringIO.new("GET some/path\n\n").tap { |s|
        s.stub(:close => true, :puts => true)
      }
    end

    before { subject.receive_data(client) }

    it 'responds with a friendly message' do
      client.should have_received(:puts).with(described_class::HTTP_RESPONSE)
    end

    it 'does not issue system commands' do
      subject.should_not have_received(:system)
    end

    it 'closes connection' do
      client.should have_received(:close)
    end
  end
end
