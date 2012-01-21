#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require File.join( File.dirname( __FILE__ ), 'conf.rb' )
Dir.chdir $conf[:dir][:root]
require "lib/logger.rb"
require "lib/irc.rb"
require "lib/bot.rb"
require "lib/eight.rb"
require "lib/magicword.rb"

# TrunkBot - IRC Bot 
#
# The do everything wonder bot!
#
class TrunkBot < IRC

  @version = "v1.3"

  def initialize ( server, port, nick, pass, channel )
    super( server, port, nick, pass, channel )
    @bot = Bot.new( nick )
  end

  # from: the message send
  # to:   the message recipient, either the channel the message is sent in
  #       or the bot himself if the message is a direct/private one
  def do_cmd ( msg, from, to )
    @log.trace "[ do_cmd #{msg} ]"

    # message to bot responds to sender
    # message to channel responds to channel
    to = from if to == @nick

    case msg
    when /^VERSION$/i
      say "TrunkBot #{@version}", to

    else
      out = @bot.process msg
      out.split("\n").each {|line| say line, to; sleep(0.5); }
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
  
  tbot = TrunkBot.new( host, port, nick, pass, chan )
  tbot.connect()
  
  begin
    tbot.main_loop
  rescue Interrupt
  rescue Exception => detail
    puts detail.message
    print detail.backtrace.join("\n")
    retry
  end
  
end
