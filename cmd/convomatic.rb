#!/usr/bin/env ruby

n1 = ARGV[0] 
n2 = ARGV[1]

begin

  
  raise 'wrong argument count' if ARGV.length != 2

  ty = [ 'eight_ender', 'ol_qwerty_bastrd', 'HAM_RADIO', 'tyler' ]
  n1 = 'tyler' if ty.index( n1 )
  n2 = 'tyler' if ty.index( n2 )

  n1 = 'beeeee' if n1.start_with?('beeeee')
  n2 = 'beeeee' if n2.start_with?('beeeee')

  require File.join( File.dirname( __FILE__ ), '../conf.rb' )

  log1 = $conf[:dir][:root] + "/dict/q.#{n1}.log"
  log2 = $conf[:dir][:root] + "/dict/q.#{n2}.log"
  s = ''

  raise 'Missing log file' if !File.exists?( log1 ) || !File.exists?( log2 )
  
  convo = []

  phrases = []
  f = File.new( log1, "r" )
  f.each{|line| phrases << line.chomp }

  nick = n1.rjust(9)

  convo[0] = " [#{nick}]: #{phrases[rand(phrases.length)]}"
  convo[2] = " [#{nick}]: #{phrases[rand(phrases.length)]}"
  convo[4] = " [#{nick}]: #{phrases[rand(phrases.length)]}"

  nick = n2.rjust(9)
  phrases = []
  f = File.new( log2, "r" )
  f.each{|line| phrases << line.chomp }

  convo[1] = " [#{nick}]: #{phrases[rand(phrases.length)]}"
  convo[3] = " [#{nick}]: #{phrases[rand(phrases.length)]}"

  puts convo.join("\n")

rescue
  puts "usage: convomatic <nick> <nick>"

end

