#!/usr/bin/env ruby
# @file bot.rb

# The bot brains
class Bot

  @version = "v1.3"
  
  attr_accessor :nick, :version
  
  # Constructor
  def initialize nick
    require "lib/eight.rb"
    require "lib/magicword.rb"
    
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
  
  require File.join( File.dirname( __FILE__ ), '../conf.rb' )
  Dir.chdir $conf[:dir][:root]
  require "lib/logger.rb"
  require "rubygems"
  require "escape"

  puts Bot.new( 'blank' ).process ARGV.join(" ")

end