#!/usr/bin/env ruby

require 'rubygems'

gem 'activesupport'
require 'active_support'
require 'active_support/time_with_zone'

t = ActiveSupport::TimeWithZone.new(Time.now.utc, ActiveSupport::TimeZone.new('Sydney'))
puts t.strftime("crikey, it's %H:%M! (%a %b %e)")
