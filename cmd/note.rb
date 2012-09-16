#!/usr/bin/env ruby

require 'rubygems'

require 'active_record'
require 'yaml'

require_relative('../conf.rb' )

ActiveRecord::Base.establish_connection(YAML::load(File.open("#{File.dirname(File.expand_path(__FILE__))}/../db/config.yml")))

class Note < ActiveRecord::Base
end

if ARGV.length == 1
  # display note
  if n = Note.where(name: ARGV[0]).first
    puts n.content
  else
    puts "no note found for name #{ARGV[0]}"
  end

elsif ARGV.length == 0
  puts 'usage: note <name> [<text>]'

else
  # add note
  n = Note.where(name: ARGV[0]).first_or_create

  if n.update_attributes(name: ARGV.shift, content: ARGV.join(" "))
    puts "note saved"
  else
    puts "error saving the note"
  end

end
