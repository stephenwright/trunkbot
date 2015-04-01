#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require "escape"

class WeatherTrunk

  def to_c f
    return ( ( f.to_f - 32 ) / 9 * 5 ).to_i
  end

  def lookup q
    uri = "http://www.google.com/ig/api?weather=#{URI.escape(q)}"
    doc = Nokogiri::XML( open( uri ) )
    return "weather unknown" if doc.css('forecast_information').empty?

    city = doc.css('forecast_information > city')[0]['data']
    curr = doc.css('current_conditions > temp_c')[0]['data']
    cond = doc.css('current_conditions > condition')[0]['data']
    cast = []
    doc.css('forecast_conditions').each { |fcast|
      day = fcast.css('day_of_week')[0]['data']
      hi = to_c fcast.css('high')[0]['data']
      lo = to_c fcast.css('low')[0]['data']
      cast.push("#{day} #{hi}/#{lo}")
    }
    return "#{city} :: #{curr}, #{cond} :: #{cast.join(' | ')}"
  end
  
end

if __FILE__ == $0
  q = ARGV[0] ? ARGV.join(" ") : "Burlington, ON"
  #puts "weather for: #{URI.escape( q )}"
  puts WeatherTrunk.new.lookup q
end
