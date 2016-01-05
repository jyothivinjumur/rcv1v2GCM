#!/bin/bash

# You first make a big test-train split (1000 documents in train, rest in test)
# Then off the train-split, you further make a train-test split () for 10-fold CV
# You build the model on train and test held-out set using  svmPerf

tc=1000 # total number of training files
dfp=/fs/clip-ediscovery/jyothi/Research/jvdofs/mfpadat
exp_dir=$(pwd)
echo " The current working Dir is : $exp_dir"
wd=/fs/clip-ediscovery/jyothi/Research/jvdofs/workdir/fpaFiles
paste -d ' ' $dfp/rcv1_CCAT.txt $dfp/rcv1_features.txt | shuf >> $wd/combineddatafile.temp.dat
lc=`cat $wd/combineddatafile.temp.dat | wc -l`
echo $lc
head -n $tc $wd/combineddatafile.temp.dat >> $wd/trainf.$tc.count.dat
let "ctail=lc-tc"
echo $ctail
tail -n $ctail $wd/combineddatafile.temp.dat >> $wd/testf.804414-$tc.dat

trainInsCount=`cat $wd/trainf.$tc.count.dat | wc -l`
echo $trainInsCount
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
 echo "Train Interation number $i"
 cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 pd=$(pwd)
 echo "The current working Dir is : $pd"
 if [ $i -eq 1 ]
 then
 	cp $bin1 $wd/testfiter$i.dat
	cat $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 2 ]
 then
 	cp $bin2 $wd/testfiter$i.dat
	cat $bin1 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 3 ]
 then
 	cp $bin3 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 4 ]
 then
 	cp $bin4 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin5 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 5 ]
 then
 	cp $bin5 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin4 $bin6 $bin7 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 6 ]
 then
 	cp $bin6 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin7 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 7 ]
 then
 	cp $bin7 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin8 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 8 ]
 then
 	cp $bin8 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin9 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 elif [ $i -eq 9 ]
 then
 	cp $bin9 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin10 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 else
 	cp $bin10 $wd/testfiter$i.dat
	cat $bin1 $bin2 $bin3 $bin4 $bin5 $bin6 $bin7 $bin8 $bin9 >> $wd/trainfiter$i.dat
	cd /fs/clip-ediscovery/jyothi/Research/svm_perf
 	./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainfiter$i.dat $wd/modeliter$i.dat
 	./svm_perf_classify $wd/testfiter$i.dat $wd/modeliter$i.dat $wd/predsiter$i.dat
 	echo "Completed Training and Testing for iteration $i"
 fi
done

#Call python script to get the value of FP and FN and TP and TN
# Get the lower bound CI

thetall=$(python /Users/jyothi/Documents/Research/jvdofs/rcv1v2/pkgcls/Main.py 2>&1)


#If returns true:

# proceed to test on the test set $wd/testf.804414-$tc.dat


cd /fs/clip-ediscovery/jyothi/Research/svm_perf
./svm_perf_learn -c 1000 -w 3 -l 3 $wd/trainf.$tc.count.dat $wd/model.trainCount.$tc.dat
./svm_perf_classify $wd/testf.804414-$tc.dat $wd/model.trainCount.$tc.dat $wd/prediction.trainCount.$tc.dat

Local Machine

./svm_perf_learn -c 1000 -w 3 -l 3 /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/trainf.1000.count.dat /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/model.trainCount.1000.test1.dat
./svm_perf_classify /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/trainf.1000.count.dat  /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/model.trainCount.1000.test1.dat /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/prediction.trainCount.1000.training.dat

./svm_perf_classify /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/testf.804414-1000.dat /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/model.trainCount.1000.test1.dat /Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/prediction.trainCount.1000.test1.dat

# You get the Matrix by adding up all the values and dividing each cell by the total due to infinite population assumption
# Repeat the process for tc=1000,2000,3000,4000,... until you get the certification test-set size
