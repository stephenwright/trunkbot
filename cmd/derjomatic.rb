#!/usr/bin/env ruby

require File.join( File.dirname( __FILE__ ), '../conf.rb' )

phrases = []
f = File.new( $conf[:dir][:root] + "/dict/q.derjur.log", "r" )
f.each{|line| phrases << line.chomp }

s  = '  ' + phrases[rand(phrases.length)] + "\n"
s += '  ' + phrases[rand(phrases.length)] + "\n"
s += '  ' + phrases[rand(phrases.length)] + "\n     - derjur"

puts s

