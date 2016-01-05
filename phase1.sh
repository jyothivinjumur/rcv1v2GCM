#!/bin/bash

declare -a arr=("C15" "C18" "C17")
responsiveCategory="C15"
declare -a privilegeCategory=("C18" "C17")
#For different train-test splits
for trainSize in 10000 15000 20000 25000 30000 35000 40000 45000 50000
do
  cd /fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/expwd/$responsiveCategory
  respWD=$(pwd)
  if [ ! -d "jcmFiles" ]; then
    mkdir jcmFiles
  fi

  for pC in "${privilegeCategory[@]}"
  do
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/expwd
    cd $pC
    privWD=$(pwd)
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/expwd/$responsiveCategory/jcmFiles
    if [ ! -d "$pC" ]; then
      mkdir $pC
      cd $pC
      mkdir pickleFiles
    else
      cd $pC
    fi
    jcmWD=$(pwd)
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs
    python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/p1Caller.py $jcmWD $respWD $privWD $trainSize
    echo "STATUS: PHASE1 Completed on $trainSize samples; Responsive category is $responsiveCategory, Privleged Category is $pC"
  done
done
