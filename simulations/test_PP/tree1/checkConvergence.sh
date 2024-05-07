#!/bin/bash

maxReps=50

echo rep	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6AB	theta_7CD	tau_5ABCD	tau_6AB	tau_7CD	M_A-B	M_B-A	M_C-D	M_D-C	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6AB	theta_7CD	tau_5ABCD	tau_6AB	tau_7CD	M_A-B	M_B-A	M_C-D	M_D-C > means
for ((reps=1;reps<=${maxReps};reps++));
do 
	mean1=$(grep mean rep${reps}_1/infOut | tail -n 1 | awk '{for(i=2;i<=15;i++) printf $i" "; print ""}' )
	mean2=$(grep mean rep${reps}_2/infOut | tail -n 1 | awk '{for(i=2;i<=15;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $reps $mean1 $mean2 >> means
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6AB	theta_7CD	tau_5ABCD	tau_6AB	tau_7CD	M_A-B	M_B-A	M_C-D	M_D-C	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6AB	theta_7CD	tau_5ABCD	tau_6AB	tau_7CD	M_A-B	M_B-A	M_C-D	M_D-C > variance

for ((reps=1;reps<=${maxReps};reps++));
do 
	mean1=$(grep 'S.D' rep${reps}_1/infOut | tail -n 1 | awk '{for(i=2;i<=15;i++) printf $i" "; print ""}' )
	mean2=$(grep 'S.D' rep${reps}_2/infOut | tail -n 1 | awk '{for(i=2;i<=15;i++) printf $i" "; print ""}' )
	echo $reps $mean1 $mean2 >> variance
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6AB	theta_7CD	tau_5ABCD	tau_6AB	tau_7CD	M_A-B	M_B-A	M_C-D	M_D-C	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6AB	theta_7CD	tau_5ABCD	tau_6AB	tau_7CD	M_A-B	M_B-A	M_C-D	M_D-C > ESS
for ((reps=1;reps<=${maxReps};reps++));
do 
	mean1=$(grep ESS rep${reps}_1/infOut | tail -n 1 | awk '{for(i=2;i<=15;i++) printf $i" "; print ""}' )
	mean2=$(grep ESS rep${reps}_2/infOut | tail -n 1 | awk '{for(i=2;i<=15;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $reps $mean1 $mean2 >> ESS
done
