#! /usr/bin/env bash

#tumors=(13 15 17 23 25 29 33 35 37 41)
#normals=(14 16 18 24 26 30 34 36 38 42)
#tumors=(17 23 25 29 37 41)
#normals=(18 24 26 30 38 42)
tumors=(3 11 13 15 17 25 29 33 37 41)
normals=(4 12 14 16 18 26 30 34 38 42)

for id in {0..9}
do
	tumor=${tumors[$id]}A
	normal=${normals[$id]}A
	echo sbatch ./process3.sh $tumor $normal
	sbatch ./process3.sh $tumor $normal
done
