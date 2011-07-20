#!/usr/bin/env ruby

require 'lib/magicword'

msg = ARGV[0] || ''

if msg.downcase.include? MagicWord.todays_word  then
  puts "you said the magic word!"
  puts "KICK you :YOU SAID THE MAGIC WORD!!"
else
  puts "you said: #{msg}"
  puts "failed to say today's word: #{MagicWord.todays_word}"
end

