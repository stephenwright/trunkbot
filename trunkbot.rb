#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "date"
require "socket"

require File.join( File.dirname( __FILE__ ), 'conf.rb' )
require $conf[:dir][:root] + "lib/bot.rb"
require $conf[:dir][:root] + "lib/eight.rb"
require $conf[:dir][:root] + "lib/magicword.rb"

class IRC

  @version = "v1.2"

  def msg txt, type=:std
    case type
      when :std
        $stdout.puts txt
      when :err
        $stderr.puts txt
    end
  end

  def log msg, chan=@chan
    if $conf[:log][:enabled]
      log_dir = $conf[:log][:dir]
      f = File.open("#{log_dir}#{chan.sub('#','')}.#{Date.today}.log", "a")
      f.write("[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n")
      f.close
    end
  end
  
  def log_raw msg
    if $conf[:log][:raw]
      log_dir = $conf[:irc][:logs]
      f = File.open("#{log_dir}raw.#{Date.today}.log", "a")
      f.write("[#{Time.now.strftime('%H:%M:%S')}] #{msg}\n")
      f.close
    end
  end

  def initialize server, port, nick, pass, channel
    @serv = server
    @port = port
    @nick = nick
    @pass = pass
    @chan = channel
    @bot  = Bot.new
  end

  def send s
    puts "--> #{s}\n"
    @irc.send "#{s}\n", 0
  end

  def say msg, to
    send "PRIVMSG #{to} :#{msg}"
  end

  def connect
    @irc = TCPSocket.open(@serv, @port)
    send "NICK #{@nick}"
    send "PASS #{@pass}"
    send "USER TrunkBot bird trunkbit.com work"
    send "PRIVMSG NickServ :identify #{@pass}"
    send "JOIN #{@chan}"
  end

  def handle_server_input(s)
  	s.strip!

    if /^PING :(.+)$/i =~ s # Reply to PINGs to keep the connection alive
      send "PONG :#{$1}"
      return
    end

    puts "<-- #{s}\n"
    log_raw s
    
    # Messages from Server should come as follows:
    # :<nick>!<userName>@<userDomain> <action> <action-specific-parameters>
    handle_action $1, $2, $3 if /^:(.+?)\s(.+?)\s(.*)/ =~ s
  end

  def handle_action source, action, params
    #puts "[ handle_action from '#{source}' #{action}: #{params}]"
    
    usr = source.split('!')[0] # pull nick from "nick!user@domain"
    chn = params.split(' ')[0] # channel specific actions have channel name as 1st parameter

    case action
    when /(\d\d\d)/ # Server Message
      handle_action_server $1

    when 'TOPIC' # params "<channel> :<topic>"
      log "#{usr} TOPIC #{params}", chn

    when 'JOIN' # params ":<channel>"
      chn.sub!(/^:/, '')
      log "#{usr} JOIN #{chn}", chn
      do_greet = ( usr =~ /_ender$|^derjur$|^office_|^eight_/ ).nil?
      send "PRIVMSG #{chn} :Hello #{usr}" if usr != @nick && do_greet

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
      handle_action_msg msg, usr, to
    end
  end

  def handle_action_server action
    case action
      # Names List
    when 353 # namelist
    when 366 # end of /names
      # Message Of The Day
    when 375 # MOTD start
    when 372 # MOTD line
    when 376 # MOTD end
    end
  end

  def handle_action_msg msg, from, to
    #puts "[ handle_action_msg ]"
    log "#{to}.#{from}:#{msg}", to
    return if from == @nick
    
    if to == @nick
      # message to bot
      do_cmd msg, from, to
    else
      # message to channel
      if MagicWord.is_in? msg
        #say "#{from} said the magic word!", to
        say "EXTERMINATE.", to
        send "KICK #{to} #{from} :*zap*"
        return
      end

      if /^the game$/i =~ msg
        send "KICK #{to} #{from} :you know what you did..."
      end

      case msg
      when /^(#{@nick}[:,]?\s|!)(.+)/
        do_cmd $2, from, to
	    end
    end
  end

  # from: the message send
  # to:   the message recipient, either the channel the message is sent in
  #       or the bot himself if the message is a direct/private one
  def do_cmd msg, from, to
    #puts "[ do_cmd #{cmd} ]"

    # message to bot responds to sender
    # message to channel responds to channel
    to = from if to == @nick

    case msg

    when /^VERSION$/i
      say "TrunkBot #{@version}", to

    when /(.+?)\s?>\s?(\w+)$/
      puts "[ Directed Command; cmd:#{$1}, trg:#{$2} ]"
      to = $2
      out = @bot.process $1
      out.split("\n").each {|line| say line, to; sleep(0.5); }

    else
      out = @bot.process msg
      out.split("\n").each {|line| say line, to; sleep(0.5); }
    end
  end

  def main_loop
    while true
      
      ready = select([@irc, $stdin], nil, nil, nil)
      next unless ready
      
      if ready[0].include? $stdin then
        return if $stdin.eof
        send $stdin.gets
      elsif ready[0].include? @irc then
        return if @irc.eof
        handle_server_input(@irc.gets)
      end
      
    end
  end
  
end

# Main
if __FILE__ == $0 then

  host = $conf[:irc][:host]
  nick = $conf[:irc][:nick]
  pass = $conf[:irc][:pass]
  chan = $conf[:irc][:chan]
  port = 6667
  irc = IRC.new(host, port, nick, pass, chan)
  irc.connect()
  begin
    irc.main_loop
  rescue Interrupt
  rescue Exception => detail
    puts detail.message
    print detail.backtrace.join("\n")
    retry
  end
  
end
