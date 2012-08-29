#!/bin/bash

NICKS=('derjur' 'dr_summer' 'beeeee' 'chelsea_' 'ol_qwerty_bastrd')

for n in "${NICKS[@]}"; do
	grep "b33r_time.${n}:" b33r* | sed "s/^b33r_time.*${n}://" | sort -u > q.${n}.log
done

