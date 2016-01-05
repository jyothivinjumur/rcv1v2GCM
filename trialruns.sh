 #!/bin/bash



 for trainInsNumber in "${instanceNumArrayTrain[@]}";
 do
   sed -n "${trainInsNumber}p" $wd/combined.$rCategory.datafile.temp.dat
 done >> $wd/trainf.$trainSize.count.dat
 cut -d' ' -f1 $wd/trainf.$trainSize.count.dat >> $wd/trainf.$trainSize.count.lables.dat


 echo "Number of Test Instances $NumTestInstances"
 echo " length of the Test array is: "
 echo ${#instanceNumArrayTest[@]}


 counter=0
 for testInsNumber in "${instanceNumArrayTest[@]}";
 do
   if [ $counter -le $NumTestInstances ]
   then
     sed -n "${testInsNumber}p" $wd/combined.$rCategory.datafile.temp.dat
     counter=`expr 1 + $counter`
   fi
 done >> $wd/testinsf.$trainSize.dat



shuf filename >> f2.txt
tc=10


n=$(sed -n "1, $tc p" temp2.csv)
instanceNumArray=($n)

for trainInsNumber in "${instanceNumArray[@]}";
do
  echo $trainInsNumber;
done

PARA=(-7.5365773652079699,-2.8449140704080476)
RankedList.py /Users/jyothi/Documents/Research/jvdofs/rcv1v2/results $PARA /Users/jyothi/Documents/Research/jvdofs/rcv1v2/results/C15/prediction.tCount.10000.dat /Users/jyothi/Documents/Research/jvdofs/rcv1v2/results/C15/testinsf.10000.count.lables.dat 10000



# filename="/Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/tempTesting/trainf.1000.count.lables.dat"
# negCtr=0
# while read -r line
# do
#     if [[ $line =~ '-' ]]; then
#       negCtr=$((negCtr+1))
#     fi
# done < "$filename"
#
# lc=1000
# posCtr=$(expr $lc - $negCtr)
#
# tc=1000
# wd=/Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/tempTesting
# testPredictions=/Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/tempTesting/prediction.training.1000.dat
# testLabels=/Users/jyothi/Documents/Research/jvdofs/rcv1v2/prjfiles/workdir/testf.804414-1000.count.lables.dat
# plattPrameters=$(python /Users/jyothi/Documents/Research/jvdofs/rcv1v2/pkgcls/PlattCaliberation.py $filename $wd/prediction.trainCount.$tc.training.dat $negCtr $posCtr)
# PARAMETERS="$(echo -e "${plattPrameters}" | tr -d '[[:space:]]')"
# echo $PARAMETERS
