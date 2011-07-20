#!/usr/bin/env ruby

if ARGV.length != 2
  puts "usage: wow <realm> <character>"

else
  r = ARGV[0] || 'firetree'
  t = ARGV[1] || 'stohen'
  
  require File.join( File.dirname( __FILE__ ), '../conf.rb' )
  require $conf[:dir][:root] + 'lib/wow.rb'
  include WorldOfWarcraft
  puts armory_lookup r,t

end
