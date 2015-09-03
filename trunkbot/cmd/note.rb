#!/usr/bin/env ruby
require_relative '../base'

if ARGV.length == 1
  # display note
  if n = Note.where(title: ARGV[0]).first
    puts n.content
  else
    puts "no note found for name #{ARGV[0]}"
  end

elsif ARGV.length == 0
  puts 'usage: note <name> [<text>]'

else
  # add note
  n = Note.where(title: ARGV[0]).first_or_create

  if n.update_attributes(title: ARGV.shift, content: ARGV.join(" "))
    puts "note saved"
  else
    puts "error saving the note"
  end

end
