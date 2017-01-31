#!/usr/bin/env ruby
require_relative '../base'

images = Image.where(private: false).order('random()')

ARGV.each do |tag|
  images = images.where('tags like ?', "%#{tag}%")
end

image = images.first

if image.present?
  puts "http://trunkbit.com/i/#{image.id}"
else
  puts "could not find an image"
end

