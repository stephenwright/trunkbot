# @file interface.rb

# base class to define interfaces for interacting with the bot 
class Interface
  
  attr_accessor :bot
  attr_accessor :running
  
  def initialize ( bot )
    @bot = bot
  end
  
  def start
    @running = true
  end
  
  def stop
    @running = false
  end
  
protected
  
  
  
end
