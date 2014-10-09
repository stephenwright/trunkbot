#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require 'yaml'

require_relative('../conf.rb' )

ActiveRecord::Base.establish_connection(
  YAML::load(File.open("#{File.dirname(File.expand_path(__FILE__))}/../db/config.yml")))

class IrcMessage  < ActiveRecord::Base
  scope :b33r, -> { where receiver: '#b33r_time' }
  scope :contains, ->(term) { where('text ~* ? and text !~* \'^!\'', "\\y#{term}\\y") }
end

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

