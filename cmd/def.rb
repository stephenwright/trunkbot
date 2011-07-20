#!/usr/bin/env ruby

require File.join( File.dirname( __FILE__ ), '../conf.rb' )
require $conf[:dir][:root] + 'lib/wordnet.rb'

if ARGV.length < 1
  puts "usage: def <word> [<number>[-<range>]]"

else
  ret = WordNet::define ARGV[0] || "test"
  defs = ret.split("\n")
  
  if ARGV.length == 2
	case ARGV[1]
	when /^(\d+)$/
	  puts defs[$1.to_i-1]
	when /^(\d+)-(\d+)$/
	  i = $1.to_i - 1
	  j = $2.to_i - 1
	  (i..j).each {|n| puts defs[n] unless defs[n] == nil }
	end
  else
    if defs.length > 6
	  (0..6).each {|n| puts defs[n] }
	  puts "Showing 1-7 of #{defs.length} definitions (the rest ommited to avoid flooding)"
	else
	  puts ret
	end
  end

end
