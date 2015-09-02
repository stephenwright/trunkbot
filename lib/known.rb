#!/usr/bin/env ruby

if __FILE__ == $0
  root_path = File.expand_path('..', File.dirname(__FILE__))
  $LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)
end

case ARGV.join(' ')
when /^do you know what time it is/,
     /^do you have the time/,
     /^what time is it/
  puts `trunkbot/cmd/time.rb`

when /i think we're alone now/
  puts %q{there doesn't seem to be anyone around.}

end

