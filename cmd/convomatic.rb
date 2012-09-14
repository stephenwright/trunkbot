#!/usr/bin/env ruby

n1 = ARGV[0] 
n2 = ARGV[1]

begin

  
  raise 'wrong argument count' if ARGV.length != 2

  ty = [ 'eight_ender', 'ol_qwerty_bastrd', 'HAM_RADIO', 'tyler' ]
  nick = 'tyler' if ty.index( nick )

  require File.join( File.dirname( __FILE__ ), '../conf.rb' )

  log1 = $conf[:dir][:root] + "/dict/q.#{n1}.log"
  log2 = $conf[:dir][:root] + "/dict/q.#{n2}.log"
  s = ''

  raise 'Missing log file' if !File.exists?( log1 ) || !File.exists?( log2 )
  
  convo = []

  phrases = []
  f = File.new( log1, "r" )
  f.each{|line| phrases << line.chomp }

  convo[0] = "#{n1}: #{phrases[rand(phrases.length)]}"
  convo[2] = "#{n1}: #{phrases[rand(phrases.length)]}"
  convo[4] = "#{n1}: #{phrases[rand(phrases.length)]}"

  phrases = []
  f = File.new( log2, "r" )
  f.each{|line| phrases << line.chomp }

  convo[1] = "#{n2}: #{phrases[rand(phrases.length)]}"
  convo[3] = "#{n2}: #{phrases[rand(phrases.length)]}"

  puts convo.join("\n")

rescue
  puts "usage: convomatic <nick> <nick>"

end

