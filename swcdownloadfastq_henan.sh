#!/usr/bin/env bash

#samples=(3A 4A 11A 12A 13A 14A 15A 16A 17A 18A 25A 26A 29A 30A 33A 34A 37A 38A 41A 42A)
#samples=(3A 14A 25A 33A 42A)
samples=(4A 11A 12A 13A 15A 16A 17A 18A 26A 29A 30A 34A 37A 38A 41A)
fromdir=/henan
todir=/fh/scratch/delete30/dai_j/henan
for sample in ${samples[@]}
do
  echo swc download $fromdir/$sample $todir/$sample
  swc download $fromdir/$sample $todir/$sample
done

