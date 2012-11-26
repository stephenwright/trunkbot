#!/usr/bin/env ruby

cmd = ARGV[0]

cmd = "nope" if rand(3) != 1

case cmd
when "on"
  puts "bo BLEEP"

when "off"
  puts "BEE bloo"

when "dim"
  puts "blee bleep"

end

