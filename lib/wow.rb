#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

module WorldOfWarcraft

  def run(args)
    r = args[0] || 'firetree'
    t = args[1] || 'stohen'
    return armory_lookup r,t
  end
  
  def armory_lookup(realm='firetree', toon='stohen')
    uri = "http://www.wowarmory.com/character-sheet.xml?r=#{realm}&n=#{toon}"
    agent = "Mozilla/5.0 Gecko/20070219 Firefox/2.0.0.2"
    doc = Nokogiri::XML(open(uri, "User-Agent" => agent))
    
    n = doc.css('page > characterInfo > character').first
    return "#{n['name']}, level #{n['level']} #{n['race']} #{n['class']}\n"
  end
  
end

if __FILE__ == $0
  include WorldOfWarcraft
  puts run ARGV
end
