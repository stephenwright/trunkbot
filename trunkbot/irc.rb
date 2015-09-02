module Trunkbot::Irc
	require 'trunkbot/irc/configuration'
	require 'trunkbot/irc/client'

  # Errors

  class MissingArgument < StandardError; end
  class SocketDisconnect < StandardError; end
  class ConnectionTimeout < StandardError; end

  # Configuration

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Trunkbot::Irc::Configuration.new
    yield config
  end

end
