#!/usr/bin/env ruby

require File.join( File.dirname( __FILE__ ), '../conf.rb' )

# check the log files for all KICK messages
# and count the number of times each user has kicked another user
#
# path: where the log files are kept
# chan: the channel to search
def readLogs(path,chan)

  # log file directory
  dir = Dir.new(path)

  # array to store the user kick counts
  kicks = {}

  # regex for finding log files
  reg = /^#{chan}\.([\d\-]+)\.log$/

  # go through all the files in the specified directory
  dir.each {|filename| 

    # skip the file if the name doesn't match the specified channel
    next unless reg.match(filename)

    # get the channel name and date from the filename of the logfile
    chan = $1
    date = $2

    # open the file and read line by line looking for KICKs
    f = File.new path + "/" + filename, "r" 
    f.each {|line|
      begin

        # keep looping until we find a log for a KICK
        next unless line =~ /^\[[\d:]+\]\s([\w\-]+?)\sKICK\s(.+?)\s(.+?)\s(.+?)\s/ # usr KICK chn trg msg

        # get kicker and kickee
        usr = $1
  	    trg = $3

        # add/increment the user's kick count
        if kicks[usr] == nil then kicks[usr] = 1 else kicks[usr] += 1 end

      rescue
        # couldn't read the line, usually because of unsupported characters
        # ignore and continue
      end
    }
  }

  # return the list of users with at least 1 kick, sorted by kick count
  return kicks.find_all{|k,v| v > 1}.sort {|a,b| b[1] <=> a[1] }
end

# this command takes 1 argument, the channel, defaults to b33r_time
chan = ARGV[0] || "b33r_time"

# get the list of top kickers
kicks = readLogs $conf[:log][:dir], chan

# print each line
kicks.each{|key,val| puts "#{key}: #{val}" }

