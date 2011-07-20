#!/usr/bin/env ruby

module EightBall

  def EightBall.ask
    srand()
    return case 1 + rand(20)
    when  1 then "As I see it, yes" 
    when  2 then "It is certain" 
    when  3 then "It is decidedly so" 
    when  4 then "Most likely" 
    when  5 then "Outlook good" 
    when  6 then "Signs point to yes" 
    when  7 then "Without a doubt" 
    when  8 then "Yes" 
    when  9 then "Yes - definitely" 
    when 10 then "You may rely on it" 
    when 11 then "Reply hazy, try again" 
    when 12 then "Ask again later" 
    when 13 then "Better not tell you now" 
    when 14 then "Cannot predict now" 
    when 15 then "Concentrate and ask again" 
    when 16 then "Don't count on it" 
    when 17 then "My reply is no" 
    when 18 then "My sources say no" 
    when 19 then "Outlook not so good" 
    when 20 then "Very doubtful" 
    end
  end
  
end

if __FILE__ == $0
  puts EightBall::ask
end
