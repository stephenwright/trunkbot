#!/usr/bin/env ruby
require_relative '../base'

images = Image.where(private: false).order('random()')

ARGV.each do |tag|
  images = images.where('tags ilike :q or name ilike :q or file_file_name ilike :q', q: "%#{tag}%")
end

image = images.first

if image.present?
  puts "http://trunkbit.com/i/#{image.id}"
else
  puts "could not find an image"
end

