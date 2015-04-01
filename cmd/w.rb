#!/usr/bin/env ruby
 
require 'rubygems'
require 'net/http'
require 'json'
  
location = ARGV[0]
   
source = "http://api.openweathermap.org/data/2.5/weather?units=metric&q=#{location}"
    
data = JSON.parse(Net::HTTP.get_response(URI.parse(source)).body)
	 
puts "Weather for #{data['name']}: #{data['weather'].first['main']}, temperature is #{data['main']['temp']} Celsius"

