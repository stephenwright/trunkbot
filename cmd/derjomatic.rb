#!/usr/bin/env ruby

require File.join( File.dirname( __FILE__ ), '../conf.rb' )

phrases = []
f = File.new( $conf[:dir][:root] + "dict/derjur.log", "r" )
f.each{|line| phrases << line.chomp }

3.times do
   puts phrases[rand(phrases.length)]
end

