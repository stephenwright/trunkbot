#!/usr/bin/env ruby
require_relative '../base'

phrases = []
f = File.new( "data/derjenerations", "r" )
f.each{|line| phrases << line.chomp }

3.times do
   puts phrases[rand(phrases.length)]
end
