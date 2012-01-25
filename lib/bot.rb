#!/usr/bin/env ruby
# @file bot.rb

# The bot brains
class Bot
  
  attr_accessor :nick, :version
  
  # Constructor
  def initialize nick
    require "lib/eight.rb"
    require "lib/magicword.rb"
    require "escape"
    
    @nick = nick
    @log = Logger.new()
  end

  # Process commands 
  def process in_str
    @log.debug "processing cmd: #{ in_str }"
    response = ''

    case in_str
    when /(.*?)\?$/
      @log.debug "[ Question asked: #{$1}? ]"
      response = EightBall.ask
    else
      args = in_str.split
      cmd = args.shift
      if (File.exist? "cmd/#{cmd}.rb")
        cmd = Escape.shell_command([ "cmd/#{cmd}.rb", *args ]).to_s
        @log.debug "COMMAND: " + cmd
        response = `#{cmd}`
      else
        @log.debug "'#{cmd}' does not compute."
      end
    end
    return response
  end

end

# Main
if __FILE__ == $0 then
  
  require "rubygems"
  require "bundler/setup"
  require File.join( File.dirname( __FILE__ ), '../conf.rb' )
  Dir.chdir $conf[:dir][:root]
  require "lib/logger.rb"

  #puts Bot.new( 'blank' ).process ARGV.join(" ")
  
  require "socket"
  require "thread"
  
  $b = Bot.new( 'funkbot' );
  @done = false
  
  def proc cmd
    case cmd
    when /quit/i
      @done = true
      puts "quiting"
      exit
    end
    return $b.process cmd
  end
  
  t_cli = Thread.new {
    loop do
      ready = select([$stdin], nil, nil, nil)
      next unless ready
      cmd = ""
      if ready[0].include? $stdin then
        # Handle command line input
        return if $stdin.eof
        cmd = $stdin.gets
        #puts "<< #{cmd}"
        puts ">> #{proc cmd}"
      end
    end
  }
  
  f = 'tmp/bot.socket'
  File.unlink( f ) if File.exists?( f ) && File.socket?( f )
  server = UNIXServer.new( f )
  while !@done
    sock = server.accept 
    Thread.new {
      puts "socket open"
      while cmd = sock.gets
          sock.puts proc cmd
          sock.puts "---done---"
      end
      puts "done"
      sock.close
    }
  end
  File.delete( f )

end
