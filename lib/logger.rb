#!/usr/bin/env ruby

class Logger
  
  # Possible log levels
  NONE  = 0
  FATAL = 1
  ERROR = 2
  WARN  = 3
  INFO  = 4
  DEBUG = 5
  TRACE = 6
  
  # Current level 
  @level = ERROR
  
  attr_accessor :level
  
  # Constructor
  def initialize ( level=INFO )
    @level = level
  end
  
  # The actual logging
  def log ( msg, level=@level )
    return if level > @level
    
    if $conf[:log][:output]
      log_dir = $conf[:log][:dir]
      f = File.open( "#{log_dir}bot.log", "w" )
      f.write( "#{msg}\n" )
      f.close
    else
      puts msg
    end
  end
  
  # Convenience
  def fatal ( msg ); log msg, FATAL; end
  def error ( msg ); log msg, ERROR; end
  def warn  ( msg ); log msg, WARN;  end
  def info  ( msg ); log msg, INFO;  end
  def debug ( msg ); log msg, DEBUG; end
  def trace ( msg ); log msg, TRACE; end

end
