#!/usr/bin/env ruby
require_relative '../base'

messages = IrcMessage.b33r.order(:created_at)

if ARGV.length > 0
  query = ARGV.join(" ")
  messages = messages.contains(query)
end

msg = messages.first

if msg
  quote = msg.text.strip.gsub(/"/, "'")
  puts "\"#{quote}\"  -#{msg.name}, #{msg.created_at}"
else
  puts "no quote found."
end
