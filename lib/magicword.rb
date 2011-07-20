#!/usr/bin/env ruby

require File.join( File.dirname( __FILE__ ), '../conf.rb' )

module MagicWord
  require 'date'

  def MagicWord.is_in? (txt)
    w = MagicWord.todays_word
    return /\b#{w}s?\b/i =~ txt
  end

  def MagicWord.todays_word
    # Gets the day of the year 1-365 and sets it as the seed for our random number.
    # This is to ensure the magic word stays the same for an entire calendar day.
    srand( Date.today.yday() )

	words = []
	f = File.new( $conf[:dir][:root] + "dict/magicwords", "r" )
	f.each{|line| words << line.chomp }

	return words[ rand( words.length ) ]
  end

end

if __FILE__ == $0
  word = MagicWord.todays_word
  test = ARGV[0] || "test"
  if MagicWord.is_in? test
    puts "test word '#{test}' is magic!"
  else
    puts "test word '#{test}' is not magic '#{word}'."
  end
end
