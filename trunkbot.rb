module Trunkbot
  require 'trunkbot/logger'
  require 'trunkbot/irc'
  require 'trunkbot/bot'
  require 'trunkbot/cmd'

  def self.known_nicks
    [
      %w{TuxOtaku TuxWork TuxAway},
      %w{azend azend|vps},
      %w{derjur},
      %w{dr_summer dr_notworking straw_man},
      %w{chelsea_ chelsea__},
      %w{vladTO},
      %w{Turdburg},
      %w{apow},
      %w{countryHick},
      %w{beeeee beeee beeeee_ beeeee__ beeeee___ beeeee____},
      %w{ol_qwerty_bastrd eight_ender HAM_RADIO tyler}
    ]
  end

  def self.alias(nick)
    self.known_nicks.each do |nicks|
      return nicks.first if nicks.include? nick
    end
    return nick
  end

end
