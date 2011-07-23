#!/usr/bin/env ruby

require 'rubygems'
require 'escape'
require 'lib/eight.rb'

class Bot

  def p msg
    $stdout.puts msg
  end

  def process in_str
    p "processing cmd: #{ in_str }"

    response = ''

    case in_str

    when /(.*?)\?$/
      p "[ Question asked: #{$1}? ]"
      response = EightBall.ask
      
    else
      args = in_str.split
      cmd = args.shift
      if (File.exist? "cmd/#{cmd}.rb")
        cmd = Escape.shell_command([ "cmd/#{cmd}.rb", *args ]).to_s
        p "COMMAND: " + cmd
        response = `#{cmd}`
      else
        p "'#{cmd}' does not compute."
      end

    end
    return response
  end

end

# Main
if __FILE__ == $0 then

  puts Bot.new.process ARGV.join(' ')
  
end
