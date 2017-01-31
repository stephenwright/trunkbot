class IrcMessage < ActiveRecord::Base
  scope :b33r, -> { where receiver: '#b33r_time' }
  scope :contains, ->(term) { where('text ~* ? and text !~* \'^!\'', "\\y#{term}\\y") }
end

