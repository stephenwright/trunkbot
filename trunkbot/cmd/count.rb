#!/usr/bin/env ruby
require_relative '../base'

if ARGV.length > 0
  query = ARGV.join(" ")
  messages = IrcMessage.b33r
    .contains(query)
    .select('name,count(*) as "count"')
    .group(:name)
    .order('count desc')
    .limit(3)

  s = ''
  messages.each {|m| s += "#{m.name} - #{m.count}\n" }
  puts s

else
  puts "usage: count <term>"

end

