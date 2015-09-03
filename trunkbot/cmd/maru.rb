#!/usr/bin/env ruby
require_relative '../base'

require 'rss'
require 'open-uri'

source = "http://gdata.youtube.com/feeds/base/users/mugumogu/uploads?start-index=1&max-results=50"
maru_feed = RSS::Parser.parse(source)
rand_feed_num = rand(maru_feed.items.size+1)

puts "^-^ Maru for you --> #{maru_feed.items[rand_feed_num].link.href}"
