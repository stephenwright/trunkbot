#!/bin/bash

NICKS=('derjur' 'dr_summer' 'beeeee' 'chelsea_' 'ol_qwerty_bastrd' 'vladTO')

for n in "${NICKS[@]}"; do
	grep "b33r_time.${n}:" log/b33r* | sed "s/^log\/b33r_time.*${n}://" | sort -u > dict/q.${n}.log
done

