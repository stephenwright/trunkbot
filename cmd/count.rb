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

