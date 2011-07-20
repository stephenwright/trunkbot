#!/usr/bin/env ruby

require 'rubygems'

gem 'activerecord', '= 2.3.11'
require 'active_record'


require File.join( File.dirname( __FILE__ ), '../conf.rb' )

ActiveRecord::Base.establish_connection(
  :adapter  => $conf[:db][:adapter],
  :database => $conf[:db][:database],
  :username => $conf[:db][:username],
  :password => $conf[:db][:password],
  :host     => $conf[:db][:host])

class Note < ActiveRecord::Base
end

if ARGV.length == 1
  # display note
  n = Note.find(:first, :conditions => ['name = ?', ARGV[0]])

  if n 
    puts n.content
  else
    puts 'no note found'
  end

elsif ARGV.length == 2
  # add note
  n = Note.find(:first, :conditions => ['name = ?', ARGV[0]]) || Note.new 
  
  n.name = ARGV[0]
  n.content = ARGV[1]

  if n.save
    puts "note saved"
  else
    puts "error saving the note"
  end

else
  puts 'usage: note <name> ["<text>"]'

end
