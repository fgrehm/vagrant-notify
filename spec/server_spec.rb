require 'vagrant-notify/server'

describe Vagrant::Notify::Server do
  let(:arguments)  { '{"message":"It Works!"}' }
  let(:client)     { StringIO.new(arguments) }
  let(:sender_app) { 'notify-send' }
  let(:sender_params_str) { "[--app-name {app_name}] [--urgency {urgency}] [--expire-time {expire_time}] [--icon {icon}] [--category {category}] [--hint {hint}] {message}" }
  let(:sender_params_escape) { true }
  let(:machine_id) { 'machine-id' }
  let(:return_string) { '"It Works!"'}

  subject { described_class.new(machine_id, sender_app, sender_params_str, sender_params_escape) }

  before { subject.stub(:system => true) }

  it 'runs notify-send with received data from client' do
    subject.should_receive(:system).with("#{sender_app}       #{return_string}") #server.rb needs to be updated so it strips this exta white space in the response
    subject.receive_data(client)
  end

  it 'closes connection after reading data' do
    client.should_receive(:close)
    subject.receive_data(client)
  end

  context 'notification with an icon' do
    let(:arguments) { '{"icon":"-tmp-foo-bar.jpg","message":"Test message"}' }

    before { subject.receive_data(client) }

    it 'rewrites icon path before sending the notification' do
      subject.should have_received(:system).with("#{sender_app}    --icon \"-tmp-foo-bar.jpg\"   \"Test message\"")
    end
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
