#!/bin/env ruby

def nickParse aliases
#	echo '' > dict/tmp.log
  #File.open 'tmp.log' 'w'
  aliases.each {|a| 
    #File.open 'log' 'r'
    p "alias: #{a}"
  }
#	for n in "${nicks[@]}"; do
#		grep "b33r_time.${n}:" log/**/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
#		grep "b33r_time.${n}:" log/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
#	done
#	cat dict/tmp.log | sort -u > dict/q.${nick}.log
# rm dict/tmp.log
end

nicks = [
	['TuxOtaku', 'TuxWork', 'TuxAway'],
	['derjur'],
	['dr_summer', 'dr_notworking', 'straw_man'],
	['chelsea_'],
	['vladTO'],
	['Turdburg'],
	['apow'],
	['beeee', 'beeeee', 'beeeee_', 'beeeee__', 'beeeee___', 'beeeee____'],
	['ol_qwerty_bastrd', 'eight_ender', 'HAM_RADIO']]

nicks.each {|n| nickParse n }

