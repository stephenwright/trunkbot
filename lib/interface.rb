# @file interface.rb

# base class to define interfaces for interacting with the bot 
class Interface
  
  attr_accessor :bot
  
  def initialize ( bot )
    @bot = bot
  end
  
  def start
  end
  
  def stop
  end
  
protected
  
  
  
end
