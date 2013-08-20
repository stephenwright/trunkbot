#!/bin/bash

NICKS=('TuxOtaku' 'derjur' 'dr_summer' 'chelsea_' 'vladTO' 'Turdburg')

for n in "${NICKS[@]}"; do
	grep "b33r_time.${n}:" log/**/b33r* | sed "s/^log.*\/b33r_time.*${n}://" > dict/tmp.log
	grep "b33r_time.${n}:" log/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
	cat dict/tmp.log | sort -u > dict/q.${n}.log
done

# special handling of tyler's many nicks
NICKS=('ol_qwerty_bastrd' 'eight_ender' 'HAM_RADIO')
echo '' > dict/tmp.log
for n in "${NICKS[@]}"; do
	grep "b33r_time.${n}:" log/**/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
	grep "b33r_time.${n}:" log/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
done
cat dict/tmp.log | sort -u > dict/q.tyler.log

# special handling for the bee
NICKS=('beeee' 'beeeee' 'beeeee_' 'beeeee__')
echo '' > dict/tmp.log
for n in "${NICKS[@]}"; do
	grep "b33r_time.${n}:" log/**/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
	grep "b33r_time.${n}:" log/b33r* | sed "s/^log.*\/b33r_time.*${n}://" >> dict/tmp.log
done
cat dict/tmp.log | sort -u > dict/q.beeeee.log

rm dict/tmp.log

