# @file irc.rb

require "rubygems"
require "bundler/setup"
require "date"
require "socket"

# the IRC class 
class IRC
  
  # Logging
  # ===========================================================================

  def log ( msg, chan=@chan )
    if $conf[:log][:enabled]
      log_dir = $conf[:log][:dir]
      f = File.open( "#{log_dir}#{chan.sub('#','')}.#{Date.today}.log", "a" )
      f.write( "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n" )
      f.close
    end
  end

  def log_raw ( msg )
    if $conf[:log][:raw]
      log_dir = $conf[:log][:dir]
      f = File.open( "#{log_dir}raw.#{Date.today}.log", "a" )
      f.write( "[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n" )
      f.close
    end
  end
  
  # Constructor
  def initialize ( server, port, nick, pass, channel )
    @log = Logger.new()
    @log.level = Logger::DEBUG
    @serv = server
    @port = port
    @nick = nick
    @pass = pass
    @chan = channel
  end


  # Handle communications with server
  # ===========================================================================
  
  # Initialize connection to IRC server
  def connect
    @log.info "[ connect ]"
    @log.info "#{@serv} #{@port}"
    
    @socket = TCPSocket.open( @serv, @port )
    send "NICK #{@nick}"
    send "USER TrunkBot bird trunkbit.com work"
    if @pass
      send "PASS #{@pass}"
      send "PRIVMSG NickServ :identify #{@pass}"
    end
    send "JOIN #{@chan}"
  end
  
  # Push messages to the server
  def send ( s )
    @log.info "--> #{s}\n"
    @socket.send "#{s}\n", 0
  end
  
  # Send a message to a channel or user
  def say msg, to
    send "PRIVMSG #{to} :#{msg}"
  end
  
  # kick a user from the target channel
  def kick ( chn, usr, msg )
    send "KICK #{chn} #{usr} :#{msg}"
  end
  
  # Receive messages sent from the server
  def receive_message ( s )
    s.strip!

    if /^PING :(.+)$/i =~ s # Reply to PINGs to keep the connection alive
      send "PONG :#{$1}"
      return
    end
    
    @log.info "<-- #{s}\n"
    log_raw s

    # Messages from Server should come as follows:
    # :<nick>!<userName>@<userDomain> <action> <action-specific-parameters>
    process_message $1, $2, $3 if /^:(.+?)\s(.+?)\s(.*)/ =~ s
  end
  
  
  # Deal with messages from the server
  # ===========================================================================
  
  # Process message received from the server
  def process_message ( source, action, params )
    @log.trace "[ process_message #{source} #{action} #{params} ]"

    usr = source.split('!')[0] # pull nick from "nick!user@domain"
    chn = params.split(' ')[0] # channel specific actions have channel name as 1st parameter

    case action
    when /(\d\d\d)/ # Three digit code
      action_code $1

    when 'TOPIC' # params "<channel> :<topic>"
      log "#{usr} TOPIC #{params}", chn

    when 'JOIN' # params ":<channel>"
      chn.sub!(/^:/, '')
      log "#{usr} JOIN #{chn}", chn
      send "PRIVMSG #{chn} :Hello #{usr}" if usr != @nick

    when 'KICK' # params "<channel> <target> :<msg>"
      prm = params.split(" ", 3)
      trg = prm[1]
      msg = prm[2]
      log "#{usr} KICK #{chn} #{trg} #{msg}", chn

    when 'INVITE' # params "<target> :<chan>"
      prm = params.split(" ", 2)
      trg = prm[0];
      chn = prm[1].sub(/^:/, '')
      send "JOIN #{chn}"
      log "#{usr} INVITE #{trg} :#{chn}"

    when 'QUIT' 
    when 'PART' 
    when 'NICK'
    when 'MODE'

    when 'PRIVMSG' 
      /(.+?)\s:(.+)/.match(params)
      to = $1
      msg = $2
      action_privmsg msg, usr, to
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
  def action_privmsg ( msg, usr, trg )
    @log.trace "[ action_privmsg ]"
    
    log "#{trg}.#{usr}:#{msg}", trg
    return if usr == @nick
    
    if trg == @nick
      # message to bot
      do_cmd msg, usr, usr
    else
      # message to channel
      if MagicWord.is_in? msg
        say "EXTERMINATE.", trg
        kick trg, usr, "*zap*"
        return
      end
      
      case msg
      when /^the game$/i
        kick trg, usr, "you know what you did..."
        
      when /(.+?)\s?>\s?(\w+)$/
        @log.debug "[ Directed Command; cmd:#{$1}, trg:#{$2} ]"
        do_cmd $1, usr, $2

      when /^(#{@nick}[:,]?\s|!)(.+)/
        do_cmd $2, usr, trg
      end
    end
  end

  # from: the message send
  # to:   the message recipient, either the channel the message is sent in
  #       or the bot himself if the message is a direct/private one
  def do_cmd msg, from, to
    @log.trace "[ do_cmd #{cmd} ]"
  end

  # the Main Loop
  # ===========================================================================
  
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

end
