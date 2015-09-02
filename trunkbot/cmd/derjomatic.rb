#!/usr/bin/env ruby
require_relative '../base'

phrases = []
f = File.new( "data/q.derjur.log", "r" )
f.each{|line| phrases << line.chomp }

s  = '  ' + phrases[rand(phrases.length)] + "\n"
s += '  ' + phrases[rand(phrases.length)] + "\n"
s += '  ' + phrases[rand(phrases.length)] + "\n     - derjur"

puts s
