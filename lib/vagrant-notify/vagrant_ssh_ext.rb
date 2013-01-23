require 'vagrant/communication/ssh'

module VagrantSshExt
  # Based on https://github.com/mitchellh/vagrant/blob/1-0-stable/lib/vagrant/communication/ssh.rb#L75-L90
  def download(from, to)
    @logger.debug("Downloading: #{from} to #{to}")

    connect do |connection|
      scp = Net::SCP.new(connection)
      scp.download!(from, to)
    end
  rescue Net::SCP::Error => e
    # If we get the exit code of 127, then this means SCP is unavailable.
    raise Errors::SCPUnavailable if e.message =~ /\(127\)/
      # Otherwise, just raise the error up
      raise
  end
end

Vagrant::Communication::SSH.send :include, VagrantSshExt
