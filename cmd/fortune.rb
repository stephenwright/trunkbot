#!/usr/bin/env ruby

puts `fortune -s`.gsub "\t", "  "
