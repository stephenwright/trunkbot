#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class WeatherTrunk

  def to_c f
    return ( (f.to_f - 32) / 9 * 5 ).to_i
  end

  def lookup q
    uri = "http://www.google.com/ig/api?weather=#{q}"
    doc = Nokogiri::XML( open( uri ) )

    city = doc.css('forecast_information > city')[0]['data']
    curr = doc.css('current_conditions > temp_c')[0]['data']
    cond = doc.css('current_conditions > condition')[0]['data']
    
    out = "#{city} :: #{curr}, #{cond} :: "
    
    cast = []
    doc.css('forecast_conditions').each { |fcast|
      hi = to_c fcast.css('high')[0]['data']
      lo = to_c fcast.css('low')[0]['data']
      day = fcast.css('day_of_week')[0]['data']
      cast.push("#{day} #{hi}/#{lo}")
    }
    out += cast.join(" | ")
    return out
  end
  
end

if __FILE__ == $0
  puts WeatherTrunk.new.lookup ARGV[0] || "Burlington,On"
end
