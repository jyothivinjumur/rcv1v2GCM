#!/bin/bash

#declare -a arr=("CCAT")
declare -a arr=("C15")

temporaryFilePath=/fs/clip-ediscovery/project-scratch/jyothikv/Research/jvdofs/wd
for trainSize in 10000 20000 30000 40000 50000 60000 70000 80000 90000 100000
do
  dfp=/fs/clip-ediscovery/jyothi/Research/jvdofs/mfpadat
  shuf $dfp/InstancesGenerator.txt >> $dfp/tempShuffle/shuffle.$trainSize.txt
  ntrain=$(sed -n "1, $trainSize p" $dfp/tempShuffle/shuffle.$trainSize.txt)
  testInitNumber=`expr 1 + $trainSize`
  ntest=$(sed -n "$testInitNumber, 804414p" $dfp/tempShuffle/shuffle.$trainSize.txt)
  instanceNumArrayTrain=($ntrain)  # Fixing the docIDS for training on each category.
  instanceNumArrayTest=($ntest)  # Fixing the docIDS for testing on each category.
  for rCategory in "${arr[@]}"
  do
    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/fpaFiles/relevance
    if [ ! -d "$rCategory" ]; then
      mkdir $rCategory
    fi
    cd $rCategory
    wd=$(pwd)
    echo "The working dir is: $wd"
    if [ ! -d "$wd/pickleFiles" ]; then
      mkdir pickleFiles
    fi
    if [ ! -d "$wd/logFiles" ]; then
      mkdir logFiles
    fi
    if [ ! -d "$wd/predictions" ]; then
      mkdir predictions
      cd predictions
      mkdir test
      mkdir train
    fi
    if [ ! -d "$temporaryFilePath/$rCategory" ]; then
      cd $temporaryFilePath
      mkdir $rCategory
      cd $rCateogory
      mkdir trainingFPA
    fi

    cd /fs/clip-ediscovery/jyothi/Research/jvdofs/
    echo "STATUS: Starting relevance/privilege category, $rCategory"
    if [-f $wd/combined.$rCategory.datafile.temp.dat]
      then
        rm $wd/combined.$rCategory.datafile.temp.dat
    fi

    paste -d ' ' $dfp/rcv1_$rCategory.txt $dfp/rcv1_features.txt  >> $wd/combined.$rCategory.datafile.temp.dat
    for trainInsNumber in "${instanceNumArrayTrain[@]}";
    do
      sed -n "${trainInsNumber}p" $wd/combined.$rCategory.datafile.temp.dat
    done >> $wd/trainf.$trainSize.count.dat
    cut -d' ' -f1 $wd/trainf.$trainSize.count.dat >> $wd/trainf.$trainSize.count.lables.dat

    for testInsNumber in "${instanceNumArrayTest[@]}";
    do
      sed -n "${testInsNumber}p" $wd/combined.$rCategory.datafile.temp.dat
    done >> $wd/testf.804414-$trainSize.dat
    # Allocate top "x" lines in "testf.804414-$trainSize.dat" for testing so that train-test split is roughly 75-25 split.
    NumTestInstances=$((trainSize*25/100))
    head -n $NumTestInstances $wd/testf.804414-$trainSize.dat >> $wd/testinsf.$trainSize.dat
    cut -d' ' -f1 $wd/testinsf.$trainSize.dat >> $wd/testinsf.$trainSize.count.lables.dat



    binctr=`echo $(($trainSize/10))`
    bin1=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin1.dat
    bin2=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin2.dat
    bin3=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin3.dat
    bin4=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin4.dat
    bin5=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin5.dat
    bin6=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin6.dat
    bin7=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin7.dat
    bin8=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin8.dat
    bin9=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin9.dat
    bin10=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin10.dat

    head -n $binctr $wd/trainf.$trainSize.count.dat >> $bin1
    bst=`echo $(($binctr*1+1))`
    bend=`echo $(($binctr*2))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin2
    bst=`echo $(($binctr*2+1))`
    bend=`echo $(($binctr*3))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin3
    bst=`echo $(($binctr*3+1))`
    bend=`echo $(($binctr*4))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin4
    bst=`echo $(($binctr*4+1))`
    bend=`echo $(($binctr*5))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin5
    bst=`echo $(($binctr*5+1))`
    bend=`echo $(($binctr*6))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin6
    bst=`echo $(($binctr*6+1))`
    bend=`echo $(($binctr*7))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin7
    bst=`echo $(($binctr*7+1))`
    bend=`echo $(($binctr*8))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin8
    bst=`echo $(($binctr*8+1))`
    bend=`echo $(($binctr9))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin9
    bst=`echo $(($binctr*9+1))`
    bend=`echo $(($binctr*10))`
    sed -n "$bst, $bend p" $wd/trainf.$trainSize.count.dat >> $bin10

    for (( i=1; i <=10; i++ ))
    do
     if [ $i -eq 1 ]
     then
      # bin1 is the held-out test set. For TSVMs, the test-set instances are present in the training set without lables
      cp $bin1 $wd/testf.$trainSize.iter$i.dat
      bin1temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin1.temp.dat
      cut -d' ' -f2- $bin1 >> $bin1temp
      sed -i -e 's/^/0 /' $bin1temp
    	cat $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 $bin1temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
      ./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed Training and Testing : train count $trainSize , iteration $i "
     elif [ $i -eq 2 ]
     then
     	cp $bin2 $wd/testf.$trainSize.iter$i.dat
      bin2temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin2.temp.dat
      cut -d' ' -f2- $bin2 >> $bin2temp
      sed -i -e 's/^/0 /' $bin2temp
    	cat $bin1 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 $bin2temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed Training and Testing : train count $trainSize , iteration $i "
     elif [ $i -eq 3 ]
     then
     	cp $bin3 $wd/testf.$trainSize.iter$i.dat
      bin3temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin3.temp.dat
      cut -d' ' -f2- $bin3 >> $bin3temp
      sed -i -e 's/^/0 /' $bin3temp
    	cat $bin1 $bin2 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 $bin3temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     elif [ $i -eq 4 ]
     then
     	cp $bin4 $wd/testf.$trainSize.iter$i.dat
      bin4temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin4.temp.dat
      cut -d' ' -f2- $bin4 >> $bin4temp
      sed -i -e 's/^/0 /' $bin4temp
    	cat $bin1 $bin2 $bin3 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 $bin4temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     elif [ $i -eq 5 ]
     then
     	cp $bin5 $wd/testf.$trainSize.iter$i.dat
      bin5temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin5.temp.dat
      cut -d' ' -f2- $bin5 >> $bin5temp
      sed -i -e 's/^/0 /' $bin5temp
    	cat $bin1 $bin2 $bin3 $bin4 $bin6 $bin7 $bin8 $bin9 $bin10 $bin5temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     elif [ $i -eq 6 ]
     then
     	cp $bin6 $wd/testf.$trainSize.iter$i.dat
      bin6temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin6.temp.dat
      cut -d' ' -f2- $bin6 >> $bin6temp
      sed -i -e 's/^/0 /' $bin6temp
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin7 $bin8 $bin9 $bin10 $bin6temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     elif [ $i -eq 7 ]
     then
     	cp $bin7 $wd/testf.$trainSize.iter$i.dat
      bin7temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin7.temp.dat
      cut -d' ' -f2- $bin7 >> $bin7temp
      sed -i -e 's/^/0 /' $bin7temp
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin8 $bin9 $bin10 $bin7temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     elif [ $i -eq 8 ]
     then
     	cp $bin8 $wd/testf.$trainSize.iter$i.dat
      bin8temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin8.temp.dat
      cut -d' ' -f2- $bin8 >> $bin8temp
      sed -i -e 's/^/0 /' $bin8temp
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin9 $bin10 $bin8temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     elif [ $i -eq 9 ]
     then
     	cp $bin9 $wd/testf.$trainSize.iter$i.dat
      bin9temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin9.temp.dat
      cut -d' ' -f2- $bin9 >> $bin9temp
      sed -i -e 's/^/0 /' $bin9temp
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin10 $bin9temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     else
     	cp $bin10 $wd/testf.$trainSize.iter$i.dat
      bin10temp=$temporaryFilePath/$rCategory/trainingFPA/trainf.$trainSize.bin10.temp.dat
      cut -d' ' -f2- $bin10 >> $bin10temp
      sed -i -e 's/^/0 /' $bin10temp
    	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10temp >> $wd/trainf.$trainSize.iter$i.dat
    	cd /fs/clip-ediscovery/jyothi/Research/svm_light
     	./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat >> $wd/logFiles/tsvm.train.$trainSize.iter$i.log 2>&1
     	./svm_classify $wd/testf.$trainSize.iter$i.dat $wd/model.$trainSize.iter$i.dat $wd/predictions/train/preds.$trainSize.iter$i.dat
     	echo "STATUS: Completed CV for trainsize $trainSize ; iteration $i"
     fi
    done

    lbtheta=$(python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/LowerBoundTheta.py $wd $wd/testf.$trainSize.iter $wd/predictions/train/preds.$trainSize.iter $trainSize 2>> $wd/logFiles/lbt.err.$trainSize.file.log)
    if [[$lbtheta > 0.85]]
    then
      echo "STATUS: Lower Bound Theta is greater than threshold, $lbtheta"
      cd /fs/clip-ediscovery/jyothi/Research/svm_light
      # Now first run the model on train instances to obtain Platt Scaling Parameters (A,B)
      ./svm_learn -v 3 -p 1 $wd/trainf.$trainSize.count.dat $wd/model.trainCount.$trainSize.dat >> $wd/logFiles/tsvm.train.$trainSize.log 2>&1
      ./svm_classify $wd/trainf.$trainSize.count.dat $wd/model.trainCount.$trainSize.dat $wd/predictions/train/prediction.training.$trainSize.dat

      cd /fs/clip-ediscovery/jyothi/Research/svm_light
      cut -d' ' -f2- $wd/testinsf.$trainSize.dat >> $wd/testinsftemp.$trainSize.dat
      sed -i -e 's/^/0 /' $wd/testinsftemp.$trainSize.dat
      cat $wd/trainf.$trainSize.count.dat $wd/testinsftemp.$trainSize.dat >> $wd/trainf4tsvm.$trainSize.count.dat
      ./svm_learn -v 3 -p 1 $wd/trainf4tsvm.$trainSize.count.dat $wd/model.trainCount.$trainSize.dat >> $wd/logFiles/tsvm.finaltrain.$trainSize.log 2>&1
      ./svm_classify $wd/testinsf.$trainSize.dat $wd/model.trainCount.$trainSize.dat $wd/predictions/test/prediction.tCount.804414-$trainSize.dat

      negCtr=0
      while read -r line
      do
          if [[ $line =~ '-' ]]; then
            negCtr=$((negCtr+1))
          fi
      done < "$wd/trainf.$trainSize.count.lables.dat"
      echo "Total Number of Training samples: $trainSize"
      echo "Total Number of negative samples in Train-set: $negCtr"
      posCtr=$(expr $trainSize - $negCtr)
      echo "Total Number of positive samples in Train-set: $posCtr"
      plattPrameters=$(python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/PlattCaliberation.py $wd/trainf.$trainSize.count.lables.dat $wd/predictions/train/prediction.training.$trainSize.dat $negCtr $posCtr)
      #Documents Ranked by Utility/Risk
      PARAMETERS="$(echo -e "${plattPrameters}" | tr -d '[[:space:]]')"
      echo "STATUS: Platt caliberation Completed, $PARAMETERS"
      python /fs/clip-ediscovery/jyothi/Research/jvdofs/projectJCM/rcv1v2dat/pkgcls/RankedList.py $wd $PARAMETERS $wd/predictions/test/prediction.tCount.804414-$trainSize.dat $wd/testinsf.$trainSize.count.lables.dat $trainSize
      echo "STATUS: Ranked List Obtained"
    else
      echo "Lower Bound Theta is lesser than threshold, $lbtheta"
    fi
    echo "STATUS: Completed Training on $trainSize samples, category $rCategory"
  done
done
