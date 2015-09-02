#!/bin/env ruby

root_path = File.expand_path('..', File.dirname(__FILE__))
$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)
Dir.chdir root_path

require 'trunkbot'

def nickParse(nicks, chan='b33r_time')

  lines = []

  nicks.each do |n|
    Dir.glob("log/**/#{chan}.*.log") do |path|
      open(path, 'r:iso-8859-1') do |file|
        file.grep(/#{chan}\.#{n}:/) do |line|
          lines << line.gsub(/.*#{chan}\.#{n}:/, '')
        end
      end
    end
  end

  File.open("data/q.#{nicks.first}.log", "w+") do |log|
    lines.sort.uniq.each {|line| log.puts line }
  end

end

Trunkbot::known_nicks.each {|n| nickParse n }

