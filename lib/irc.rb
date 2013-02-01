# @file irc.rb

require "rubygems"
require "bundler/setup"
require "date"
require "socket"

# the IRC class 
class IRC < Interface
  
  attr_accessor :serv, :port, :nick, :pass

  # the Main Loop
  # ===========================================================================

  def start
    @running = true
    while @running
      ready = select( [@socket], nil, nil, nil )
      next unless ready

      # Handle messages received throught the socket
      if ready[0].include? @socket then
        return if @socket.eof
        receive_message( @socket.gets )
      end
    end
  end

  def main_loop
    loop do

      ready = select([@socket, $stdin], nil, nil, nil)
      next unless ready

      # Handle command line input
      if ready[0].include? $stdin then
        return if $stdin.eof
        send $stdin.gets

      # Handle messages received throught the socket
      elsif ready[0].include? @socket then
        return if @socket.eof
        receive_message(@socket.gets)

      end

    end
  end

  # Logging
  # ===========================================================================

  def log ( msg, chan=@chan )
    if $conf[:log][:enabled]
      log_dir = $conf[:log][:dir]
      f = File.open( "#{log_dir}/#{chan.sub('#','')}.#{Date.today}.log", "a" )
      f.write( "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n" )
      f.close
    end
  end

  def log_raw ( msg )
    if $conf[:log][:raw]
      log_dir = $conf[:log][:dir]
      f = File.open( "#{log_dir}/raw.#{Date.today}.log", "a" )
      f.write( "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n" )
      f.close
    end
  end

  # Constructor
  def initialize ( bot )
    @log = Logger.new()
    @log.level = Logger::DEBUG
    @bot = bot
  end

  # Handle communications with server
  # ===========================================================================
  
  # Initialize connection to IRC server
  def connect ( host, nick, pass=nil, port=6667 )
    @log.info "[ connect ]"
    
    @host = host
    @nick = nick
    @pass = pass
    @port = port
    
    @log.info "#{@host} #{@port}"
    
    @socket = TCPSocket.open( @host, @port )
    
    send "NICK #{@nick}"
    send "USER TrunkBot bird trunkbit.com work"
    
    if @pass
      send "PASS #{@pass}"
      send "PRIVMSG NickServ :identify #{@pass}"
    end
  end

  # Push messages to the server
  def send ( s )
    @log.info "--> #{s}\n"
    @socket.send "#{s}\n", 0
  end
  
  # Join specified channel
  def join ( chan )
    send "JOIN #{chan}"
  end
  
  # Send a message to a channel or user
  def privmsg ( to, msg )
    send "PRIVMSG #{to} :#{msg}"
  end
  
  # kick a user from the target channel
  def kick ( chn, usr, msg )
    send "KICK #{chn} #{usr} :#{msg}"
  end
  
  # invite a user to target channel
  def invite ( usr, chn )
    send "INVITE #{usr} #{chn}"
  end
  
  # Deal with messages from the server
  # ===========================================================================

  # Receive messages sent from the server
  def receive_message ( s )
    s.strip!
    if /^PING :(.+)$/i =~ s # Reply to PINGs to keep the connection alive
      send "PONG :#{$1}"
    else
      @log.info "<-- #{s}\n"
      log_raw s
  
      # Messages from Server should come as follows:
      # :<nick>!<userName>@<userDomain> <action> <action-specific-parameters>
      process_message $1, $2, $3 if /^:(.+?)\s(.+?)\s(.*)/ =~ s
    end
  end
  
  # Process message received from the server
  def process_message ( source, action, params )
    @log.trace "[ process_message #{source} #{action} #{params} ]"

    usr = source.split('!')[0] # pull nick from "nick!user@domain"
    chn = params.split(' ')[0] # channel specific actions have channel name as 1st parameter

    case action
    when 'PRIVMSG' 
      /(.+?)\s:(.+)/.match(params)
      to = $1
      msg = $2
      action_msg msg, usr, to

    when /(\d\d\d)/ # Three digit code
      action_code $1

    when 'JOIN' # :<channel>
      chn.sub!(/^:/, '')
      log "#{usr} JOIN #{chn}", chn
      send "PRIVMSG #{chn} :Hello #{usr}" if usr != @nick

    when 'KICK' # <channel> <target> :<msg>
      prm = params.split(" ", 3)
      trg = prm[1]
      msg = prm[2]
      log "#{usr} KICK #{chn} #{trg} #{msg}", chn

    when 'TOPIC' # <channel> :<topic>
      log "#{usr} TOPIC #{params}", chn

    when 'INVITE' # <target> :<chan>
      prm = params.split(" ", 2)
      trg = prm[0];
      chn = prm[1].sub(/^:/, '')
      join chn
      log "#{usr} INVITE #{trg} :#{chn}"

    when 'QUIT' 
    when 'PART' 
    when 'NICK'
    when 'MODE'
    end
  end
  
  # Handle server codes
  def action_code ( code )
    case code
      # Names List
      when 353 # namelist
      when 366 # end of /names
      
      # Message Of The Day
      when 375 # MOTD start
      when 372 # MOTD line
      when 376 # MOTD end
    end
  end
  
  # Handle PRIVMSG
  def action_msg ( msg, usr, trg )
    @log.trace "[ action_msg ]"
    
    log "#{trg}.#{usr}:#{msg}", trg
    return if usr == @nick
    
    if trg == @nick
      # message to bot
      do_cmd msg, usr, usr
    else
      # message to channel
      if MagicWord.is_in? msg
        privmsg trg, "EXTERMINATE."
        kick trg, usr, "*zap*"
        return
      end

      case msg
      when /^the game$/i
        kick trg, usr, "You know what you did..."
        
      when /^(#{@nick}[:,]?\s?|!)(.+)/
        do_cmd $2, usr, trg
      end
    end
  end

  # from: the message sender
  # to:   the message recipient, either the channel the message is sent in
  #       or the bot himself if the message is a direct/private one
  def do_cmd ( msg, from, trg )
    @log.trace "[ do_cmd #{msg} ]"
    if /(.+?)>\s?(#?\w+)$/ =~ msg
        @log.debug "[ Directed Command; cmd:#{$1}, trg:#{$2} ]"
		msg = $1
		trg = $2
	end
    out = @bot.process msg
    out.split("\n").each {|line| privmsg trg, line; sleep(0.5); }
  end
  
end
