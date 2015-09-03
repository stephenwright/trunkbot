#!/usr/bin/env ruby

if __FILE__ == $0
  root_path = File.expand_path('..', File.dirname(__FILE__))
  $LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)
end

module MagicWord
  require 'date'

  def MagicWord.is_in? (txt)
    w = MagicWord.todays_word
    return /\b#{w}\b/i =~ txt
  end

  def MagicWord.todays_word
    # Gets the day of the year 1-365 and sets it as the seed for our random number.
    # This is to ensure the magic word stays the same for an entire calendar day.
    srand( Date.today.yday() )

    words = []
    f = File.new( "data/magicwords", "r" )
    f.each{|line| words << line.chomp }

    return words[ rand( words.length ) ]
  end

end

if __FILE__ == $0
  word = MagicWord.todays_word
  test = ARGV[0] || "test"
  if MagicWord.is_in? test
    puts "'#{test}' is magic!"
  else
    puts "'#{test}' is not magic... (hint: it's '#{word}')"
  end
end
