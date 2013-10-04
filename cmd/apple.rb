#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require 'yaml'

require_relative('../conf.rb' )

ActiveRecord::Base.establish_connection(
  YAML::load(File.open("#{File.dirname(File.expand_path(__FILE__))}/../db/config.yml")))

class IrcMessage  < ActiveRecord::Base
end

query = IrcMessage.where('receiver = ? and text ilike ?', '#b33r_time', '%apple%')
offset = rand(query.count)
msg = query.first(offset: offset)

puts "\"#{msg.text.strip}\"  -#{msg.name}"

