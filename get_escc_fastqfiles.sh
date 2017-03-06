#!/usr/bin/env bash

escctumors=(ESCC-001T ESCC-002T ESCC-003T ESCC-004T ESCC-005T ESCC-006T ESCC-008T ESCC-009T ESCC-010T ESCC-011T ESCC-012T ESCC-013T ESCC-014T ESCC-015T ESCC-016T ESCC-017T ESCC-018T)
esccnormals=(ESCC-001B ESCC-002B ESCC-003B ESCC-004B ESCC-005B ESCC-006B ESCC-008B ESCC-009B ESCC-010B ESCC-011B ESCC-012B ESCC-013B ESCC-014B ESCC-015B ESCC-016B ESCC-017B ESCC-018B)
tumors=(T1 T2 T3 T4 T5 T6 T8 T9 T10 T11 T12 T13 T14 T15 T16 T17 T18)
normals=(N1 N2 N3 N4 N5 N6 N8 N9 N10 N11 N12 N13 N14 N15 N16 N17 N18)

#find ERS number
ersnumbers=($(awk '{print $1}' Run_Sample_meta_info.map))
bginumbers=($(cut -f 2 Run_Sample_meta_info.map))
erstumors=()
count=0
for esccsample in ${escctumors[@]}
do
  count1=0  
  for bginumber in ${bginumbers[@]}
  do
    if [[ $bginumber =~ $esccsample ]]
    then
      erstumors[$count]=${ersnumbers[$count1]}
      break
    fi
    (( count1=count1+1 ))
  done
  (( count=count+1 ))
done

ersnormals=()
count=0
for esccsample in ${esccnormals[@]}
do
  count1=0  
  for bginumber in ${bginumbers[@]}
  do
    if [[ $bginumber =~ $esccsample ]]
    then
      ersnormals[$count]=${ersnumbers[$count1]}
      break
    fi
    (( count1=count1+1 ))
  done
  (( count=count+1 ))
done  

swc cd /fasqfiles/EBI

filelist=($(cut -f 1 filelist.txt))
exp_ers=($(cut -f 15 Study_Experiment_Run_sample.map))
exp_filenames=($(cut -f 7 Study_Experiment_Run_sample.map))
#copy tumors
for i in {0..16}
do
  echo $i
  if [[ ! -d ${tumors[$i]} ]]; then mkdir ${tumors[$i]}; fi
  for ers in ${erstumors[$i]}
  do
    count=0
    for exper in ${exp_ers[@]}
    do
      if [[ $exper =~ $ers ]]
      then
        expfilename=${exp_filenames[$count]}
        for filelist_filename in ${filelist[@]}
        do
          if [[ ${filelist_filename} =~ $expfilename ]]
          then
            if [[ ! -f ${tumors[$i]}/${filelist_filename} ]]
            then
              echo swc download /fasqfiles/EBI/${filelist_filename} /fh/scratch/delete30/dai_j/escc/${tumors[$i]}
              swc download /fasqfiles/EBI/${filelist_filename} /fh/scratch/delete30/dai_j/escc/${tumors[$i]}
            fi
          fi
        done
      fi
      ((count=count+1))
    done
  done
done

#copy normals
for i in {0..16}
do
  echo $i
  if [[ ! -d ${normals[$i]} ]]; then mkdir ${normals[$i]}; fi
  for ers in ${ersnormals[$i]}
  do
    count=0
    for exper in ${exp_ers[@]}
    do
      if [[ $exper =~ $ers ]]
      then
        expfilename=${exp_filenames[$count]}
        for filelist_filename in ${filelist[@]}
        do
          if [[ ${filelist_filename} =~ $expfilename ]]
          then
            if [[ ! -f ${normals[$i]}/${filelist_filename} ]]
            then
              echo swc download /fasqfiles/EBI/${filelist_filename} /fh/scratch/delete30/dai_j/escc/${normals[$i]}
              swc download /fasqfiles/EBI/${filelist_filename} /fh/scratch/delete30/dai_j/escc/${normals[$i]}
            fi
          fi
        done
      fi
      ((count=count+1))
    done
  done
done
          
      
    

