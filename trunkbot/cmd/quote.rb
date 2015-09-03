#!/usr/bin/env ruby
require_relative '../base'

messages = IrcMessage.b33r

if ARGV.length > 0
  query = ARGV.join(" ")
  messages = messages.contains(query)
end

msg = messages.offset(rand(messages.count)).first

if msg
  quote = msg.text.strip.gsub(/"/, "'")
  puts "\"#{quote}\"  -#{msg.name}"
else
  puts "no quote found."
end
