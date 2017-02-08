#!/usr/bin/env ruby
require_relative '../base'

#ActiveRecord::Base.logger = Logger.new(STDOUT)

images = Image.where(private: false)

ARGV.each do |tag|
  images = images.where('tags ilike :q or name ilike :q or file_file_name ilike :q', q: "%#{tag}%")
end

image = images.order('random()').first

if image.present?
  puts "http://trunkbit.com/i/#{image.id}"
else
  puts "could not find an image"
end

