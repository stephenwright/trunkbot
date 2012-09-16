#!/usr/bin/env ruby

require_relative('../conf.rb' )

cmd_path = $conf[:dir][:root] + '/cmd'

case ARGV.join(' ')
when /^do you know what time it is/,
     /^do you have the time/,
     /^what time is it/
  puts `#{cmd_path}/time.rb`

when /i think we're alone now/
  puts 'there doesn\'t seem to be anyone around.'

end

