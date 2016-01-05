#!/bin/bash

#declare -a arr=("GCAT" "MCAT" "ECAT")
declare -a arr=("C18" "C17")


for trainSize in 10000 20000 30000 40000 50000 60000 70000 80000 90000 100000
do
  for rCategory in "${arr[@]}"
  do
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/fpaFiles/privilege
    mkdir $rCategory
    cd $rCategory
    wd=$(pwd)
    echo "The working dir is: $wd"
    mkdir pickleFiles
    mkdir trainingFPA
    mkdir logFiles
    mkdir predictions
    cd predictions
    mkdir test
    mkdir train
    dfp=/fs/clip-ediscovery/jyothi/Research/jvdofs/mfpadat/

    echo "STATUS: Starting privilege category, $rCategory"
    tc=$trainSize
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/
    if [-f $wd/combineddatafile.temp.dat]
      then
        rm $wd/combineddatafile.temp.dat
    fi
    paste -d ' ' $dfp/rcv1_$rCategory.txt $dfp/rcv1_features.txt | shuf >> $wd/combineddatafile.temp.dat
    lc=`cat $wd/combineddatafile.temp.dat | wc -l`
    head -n $tc $wd/combineddatafile.temp.dat >> $wd/trainf.$tc.count.dat
    cut -d' ' -f1 $wd/trainf.$tc.count.dat >> $wd/trainf.$tc.count.lables.dat
    let "ctail=lc-tc"
    tail -n $ctail $wd/combineddatafile.temp.dat >> $wd/testf.804414-$tc.dat
    cut -d' ' -f1 $wd/testf.804414-$tc.dat >> $wd/testf.804414-$tc.count.lables.dat

    binctr=`echo $(($tc/10))`
    bin1=$wd/trainingFPA/trainf.$tc.bin1.dat
    bin2=$wd/trainingFPA/trainf.$tc.bin2.dat
    bin3=$wd/trainingFPA/trainf.$tc.bin3.dat
    bin4=$wd/trainingFPA/trainf.$tc.bin4.dat
    bin5=$wd/trainingFPA/trainf.$tc.bin5.dat
    bin6=$wd/trainingFPA/trainf.$tc.bin6.dat
    bin7=$wd/trainingFPA/trainf.$tc.bin7.dat
    bin8=$wd/trainingFPA/trainf.$tc.bin8.dat
    bin9=$wd/trainingFPA/trainf.$tc.bin9.dat
    bin10=$wd/trainingFPA/trainf.$tc.bin10.dat

    head -n $binctr $wd/trainf.$tc.count.dat >> $bin1
    bst=`echo $(($binctr*1+1))`
    bend=`echo $(($binctr*2))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin2
    bst=`echo $(($binctr*2+1))`
    bend=`echo $(($binctr*3))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin3
    bst=`echo $(($binctr*3+1))`
    bend=`echo $(($binctr*4))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin4
    bst=`echo $(($binctr*4+1))`
    bend=`echo $(($binctr*5))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin5
    bst=`echo $(($binctr*5+1))`
    bend=`echo $(($binctr*6))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin6
    bst=`echo $(($binctr*6+1))`
    bend=`echo $(($binctr*7))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin7
    bst=`echo $(($binctr*7+1))`
    bend=`echo $(($binctr*8))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin8
    bst=`echo $(($binctr*8+1))`
    bend=`echo $(($binctr9))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin9
    bst=`echo $(($binctr*9+1))`
    bend=`echo $(($binctr*10))`
    sed -n "$bst, $bend p" $wd/trainf.$tc.count.dat >> $bin10

    for (( i=1; i <=10; i++ ))
    do
     if [ $i -eq 1 ]
     then
     	cp $bin1 $wd/testf.$tc.iter$i.dat
    	cat $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed Training and Testing : train count $tc , iteration $i "
     elif [ $i -eq 2 ]
     then
     	cp $bin2 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed Training and Testing : train count $tc , iteration $i "
     elif [ $i -eq 3 ]
     then
     	cp $bin3 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     elif [ $i -eq 4 ]
     then
     	cp $bin4 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     elif [ $i -eq 5 ]
     then
     	cp $bin5 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin4 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     elif [ $i -eq 6 ]
     then
     	cp $bin6 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin7 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     elif [ $i -eq 7 ]
     then
     	cp $bin7 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin8 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     elif [ $i -eq 8 ]
     then
     	cp $bin8 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin9 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     elif [ $i -eq 9 ]
     then
     	cp $bin9 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin10 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     else
     	cp $bin10 $wd/testf.$tc.iter$i.dat
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 >> $wd/trainf.$tc.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
     	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat
     	./svm_perf_classify $wd/testf.$tc.iter$i.dat $wd/model.$tc.iter$i.dat $wd/predictions/train/preds.$tc.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $tc ; iteration $i"
     fi
    done
    lbtheta=$(python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/LowerBoundTheta.py $wd $wd/testf.$tc.iter $wd/predictions/train/preds.$tc.iter $tc 2>> $wd/logFiles/lbt.err.$tc.file.log)

    if [[ $lbtheta > 0.85 ]]
    then
      echo "STATUS: Lower Bound Theta is greater than threshold, $lbtheta"
      cd /fs/clip-ediscovery/jyothi/Research/svm_perf
      # Now first run the model on train instances to obtain Platt Scaling Parameters (A,B)
      ./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.count.dat $wd/model.trainCount.$tc.dat
      ./svm_perf_classify $wd/trainf.$tc.count.dat $wd/model.trainCount.$tc.dat $wd/predictions/train/prediction.training.$tc.dat

      cd /fs/clip-ediscovery/jyothi/Research/svm_perf
      ./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.count.dat $wd/model.trainCount.$tc.dat
      ./svm_perf_classify $wd/testf.804414-$tc.dat $wd/model.trainCount.$tc.dat $wd/predictions/test/prediction.tCount.804414-$tc.dat

      negCtr=0
      while read -r line
      do
          if [[ $line =~ '-' ]]; then
            negCtr=$((negCtr+1))
          fi
      done < "$wd/trainf.$tc.count.lables.dat"
      echo "Total Number of Training samples: $tc"
      echo "Total Number of negative samples in Train-set: $negCtr"
      posCtr=$(expr $tc - $negCtr)
      echo "Total Number of positive samples in Train-set: $posCtr"

      plattPrameters=$(python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/PlattCaliberation.py $wd/trainf.$tc.count.lables.dat $wd/predictions/train/prediction.training.$tc.dat $negCtr $posCtr)
      #Documents Ranked by Utility/Risk
      PARAMETERS="$(echo -e "${plattPrameters}" | tr -d '[[:space:]]')"
      echo "STATUS: Platt caliberation Completed, $PARAMETERS"
      python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/RankedList.py $wd $PARAMETERS $wd/predictions/test/prediction.tCount.804414-$tc.dat $wd/testf.804414-$tc.count.lables.dat $tc
      echo "STATUS: Ranked List Obtained"
    else
      echo "Lower Bound Theta is lesser than threshold, $lbtheta"
    fi
    echo "STATUS: Completed Training on $tc samples"
  done
done
