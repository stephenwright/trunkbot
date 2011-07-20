#!/usr/bin/env ruby

require 'rubygems'
require 'tzinfo'

module Clock

  def get_time zone
    t = Time.now
    ok = true
    if zone != nil
      zone = zone.split("/").each{|x| x.capitalize!}.join("/")
      begin
        tz = TZInfo::Timezone.get(zone)
        t = tz.now
      rescue
        ok = false
      end
    end
    if ok
      return t.strftime("holy shit, it's %H:%M! (%a %b %e)") 
    else
      return "Supported timezones: http://goo.gl/ZriVF"
    end
  end

end  

if __FILE__ == $0
  include Clock
  puts get_time ARGV[0]
end
