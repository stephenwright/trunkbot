#!/usr/bin/env ruby

if __FILE__ == $0 then

  require 'rubygems'
  require 'bundler/setup'
  require 'socket'
  require 'thread'

  root_path = File.expand_path('..', File.dirname(__FILE__))
  $LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)

  require 'trunkbot'
  require 'trunkbot/logger'
end

class Bot
  require 'lib/eight'
  require 'lib/magicword'
  require 'escape'

  attr_accessor :name

  # Constructor
  def initialize(name=nil)
    @name = name || 'trunkbot'
    @log = Trunkbot::Logger.new
  end

  # Process commands
  def process in_str
    @log.debug "processing cmd: #{in_str}"

    args = in_str.split
    cmd = Escape.shell_command([ "lib/known.rb", *args ]).to_s
    response = `#{cmd}`
    return response if !response.empty?

    case in_str
    when /(.*?)\?$/
      @log.debug "[ Question asked: #{$1}? ]"
      response = EightBall.ask
    else
      cmd = args.shift
      if (File.exist? "trunkbot/cmd/#{cmd}.rb")
        cmd = Escape.shell_command([ "trunkbot/cmd/#{cmd}.rb", *args ]).to_s
        @log.debug "COMMAND: " + cmd
        response = `#{cmd}`
      else
        @log.debug "'#{cmd}' does not compute."
      end
    end
    return response
  end

end

if __FILE__ == $0 then
  $b = Bot.new
  @done = false

  def proc cmd
    case cmd
    when /quit/i
      @done = true
      puts 'quiting'
      exit
    end
    return $b.process cmd
  end

  t_cli = Thread.new {
    loop do
      ready = select([$stdin], nil, nil, nil)
      next unless ready
      cmd = ''
      if ready[0].include? $stdin then
        # Handle command line input
        return if $stdin.eof
        cmd = $stdin.gets
        p ">> #{proc cmd}"
      end
    end
  }

  Dir.chdir root_path
  f = 'tmp/bot.socket'
  File.unlink( f ) if File.exists?( f ) && File.socket?( f )
  server = UNIXServer.new( f )
  while !@done
    sock = server.accept
    Thread.new {
      puts 'socket open'
      while cmd = sock.gets
          sock.puts proc cmd
          sock.puts '---done---'
      end
      puts 'done'
      sock.close
    }
  end
  File.delete( f )

end

