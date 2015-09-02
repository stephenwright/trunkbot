#!/usr/bin/env ruby
require_relative '../base'

require 'net/http'
require 'xmlsimple'

location = ARGV[0]
source = "http://www.google.com/ig/api?weather=#{location}"
data = Net::HTTP.get_response(URI.parse(source)).body
xml_source = XmlSimple.xml_in(data, { 'KeyAttr' => 'data' })
feed = xml_source['weather'][0]

p "Weather for #{feed['forecast_information'][0]['city']}"
p "|-- Current Conditions --|"

current = feed['current_conditions'][0]

p "#{current['condition']}, temperature is #{current['temp_c']} Celsius"
p "#{current['wind_condition']}"

p "|-- Four Day Forecast --|"

feed['forecast_conditions'].each do |forecast|
  p "#{forecast['day_of_week']}: #{forecast['condition']}, high of #{((5.0/9.0) * (forecast['high'].to_s.to_f - 32.0)).to_i}C, low of #{((5.0/9.0) * (forecast['low'].to_s.to_f - 32.0)).to_i}C"
end
