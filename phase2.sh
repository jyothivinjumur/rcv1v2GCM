#!/bin/bash

responsiveCategory="C15"
declare -a privilegeCategory=("C18" "C17")

#For different train-test splits
rJP=/fs/clip-ediscovery/jyothi/Research/jvdofs/mfpadat/rcv1_$responsiveCategory.txt
for trainSize in 10000 15000 20000 25000 30000 35000 40000 45000 50000
do
  for pC in "${privilegeCategory[@]}"
  do
    wd=/fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/expwd/C15/jcmFiles/$pC/pickleFiles
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls
    python p2Caller.py $wd $trainSize $rJP
  done
done
