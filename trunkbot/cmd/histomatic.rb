#!/usr/bin/env ruby
require_relative '../base'

nick = ARGV[0]

if nick
  nick = Trunkbot::alias nick
  log = "data/q.#{nick}.log"
  s = ''

  if File.exists? log
    phrases = []
    f = File.new( log, "r" )
    f.each{|line| phrases << line.chomp }

    s += '  ' + phrases[rand(phrases.length)] + "\n"
    s += '  ' + phrases[rand(phrases.length)] + "\n"
    s += '  ' + phrases[rand(phrases.length)] + "\n     -#{nick}"

  else
    s = "no log found for #{nick}"

  end

  puts s

else
  puts "usage: histomatic <nick>"

end
