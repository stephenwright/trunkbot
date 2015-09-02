#!/usr/bin/env ruby
require_relative '../base'

def lastQuote(user, back, chan)
  num = back.to_i
  dir = Dir.new("log/")
  reg = /^#{chan}\.([\d\-]+)\.log$/
  dir.sort.reverse_each {|filename| if reg.match(filename) then
    f = File::open path+filename, "r"
    f.sort.reverse_each {|line|
      if line =~ /^\[([\d:]+)\]\s.+?\.#{user}:(.+)$/ # chan.user:msg
    return "#{$1} <#{user}> #{$2}" if (num -= 1) <= 0
    end
    }
  end}
  return "not found"
end

user = ARGV[0] || "dr_summer"
back = ARGV[1] || 1
chan = ARGV[2] || "b33r_time"
puts lastQuote user, back, chan
