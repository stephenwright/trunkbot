#!/usr/bin/env ruby
  
require File.join( File.dirname( __FILE__ ), '../conf.rb' )
require $conf[:dir][:root] + 'lib/eight.rb'
puts EightBall.ask
