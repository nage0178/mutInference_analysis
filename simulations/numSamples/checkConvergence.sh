#!/bin/bash


echo rep	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C > means

#for ((reps=1;reps<=${maxReps};reps++));
for rep in  {1..30}/{10,100,200}
do 
	mean1=$(grep mean ${rep}_1/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	mean2=$(grep mean ${rep}_2/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $rep $mean1 $mean2 >> means
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C > variance

for rep in  {1..30}/{10,100,200}
do 
	mean1=$(grep 'S.D' ${rep}_1/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	mean2=$(grep 'S.D' ${rep}_2/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	echo $rep $mean1 $mean2 >> variance
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C > ESS

for rep in  {1..30}/{10,100,200}
do 
	mean1=$(grep ESS ${rep}_1/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	mean2=$(grep ESS ${rep}_2/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $rep $mean1 $mean2 >> ESS
done

grep -v 18/100 means > tmpmeans
grep -v 18/100 variance > tmpvariance
grep -v 18/100 ESS > tmpESS

mv tmpmeans means
mv tmpvariance variance
mv tmpESS ESS
