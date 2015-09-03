#!/usr/bin/env ruby
require_relative '../base'

puts "\001ACTION #{ARGV.join(' ')}\001" if ARGV.size > 0
