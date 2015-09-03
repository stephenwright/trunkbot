#!/usr/bin/env ruby

require File.join( File.dirname( __FILE__ ), '../conf.rb' )

def readLogs(path,chan)
  dir = Dir.new(path)
  kicks = {}
  reg = /^#{chan}\.([\d\-]+)\.log$/
  dir.each {|filename| if reg.match(filename) then
    chan = $1
    date = $2
    f = File.new path+"/"+filename, "r"
    f.each {|line|
      begin
        next unless line =~ /^\[[\d:]+\]\s([\w\-]+?)\sKICK\s(.+?)\s(.+?)\s(.+?)\s/ # usr KICK chn trg msg
        usr = $1
        trg = $3;
        if kicks[trg] == nil then kicks[trg] = 1 else kicks[trg] += 1 end
      rescue
      end
    }
  end}
  return kicks.find_all{|k,v| v > 1}.sort {|a,b| b[1] <=> a[1] }
end

chan = ARGV[0] || "b33r_time"
kicks = readLogs $conf[:log][:dir], chan
kicks.each{|key,val| puts "#{key}: #{val}" }

