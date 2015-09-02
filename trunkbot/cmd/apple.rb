#!/usr/bin/env ruby
require_relative '../base'

query = IrcMessage.where('receiver = ? and text ilike ?', '#b33r_time', '%apple%')
offset = rand(query.count)
msg = query.first(offset: offset)

puts "\"#{msg.text.strip}\"  -#{msg.name}"
