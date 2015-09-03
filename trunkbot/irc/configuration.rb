
class Trunkbot::Irc::Configuration

  attr_accessor :host, :port, :nick, :pass, :chan
  attr_accessor :logger

  def initialize
    @chan   = ''
    @pass   = nil
    @port   = 6667
    @logger = Trunkbot::Logger.new
  end

end
