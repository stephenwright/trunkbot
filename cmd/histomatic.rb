#!/usr/bin/env ruby

nick = ARGV[0] 

if nick

  ty = [ 'eight_ender', 'ol_qwerty_bastrd', 'HAM_RADIO', 'tyler' ]
  nick = 'tyler' if ty.index( nick )

  require File.join( File.dirname( __FILE__ ), '../conf.rb' )

  log = $conf[:dir][:root] + "/dict/q.#{nick}.log"
  s = ''

  if File.exists? log

    phrases = []
    f = File.new( log, "r" )
    f.each{|line| phrases << line.chomp }

    s += '  ' + phrases[rand(phrases.length)] + "\n"
    s += '  ' + phrases[rand(phrases.length)] + "\n"
    s += '  ' + phrases[rand(phrases.length)] + "\n     -#{nick}"

  else
    s = 'no log for that user'
  end

  puts s

else
  puts "usage: histomatic <nick>"
end

