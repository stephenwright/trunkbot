#!/usr/bin/env ruby
require_relative '../base'

puts `fortune -s`.gsub "\t", "  "
