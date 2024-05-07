#!/bin/bash

maxReps=50

echo rep	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6ABC	theta_7AB	tau_5ABCD	tau_6ABC	tau_7AB	M_A-C	M_C-A	M_D-ABC	M_D-AB	M_ABC-D        M_AB-D	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6ABC	theta_7AB	tau_5ABCD	tau_6ABC	tau_7AB	M_A-C	M_C-A	M_D-ABC	M_D-AB	M_ABC-D        M_AB-D > means
for ((reps=1;reps<=${maxReps};reps++));
do 
	mean1=$(grep mean rep${reps}_1/infOut | tail -n 1 | awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' )
	mean2=$(grep mean rep${reps}_2/infOut | tail -n 1 | awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $reps $mean1 $mean2 >> means
done


echo rep	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6ABC	theta_7AB	tau_5ABCD	tau_6ABC	tau_7AB	M_A-C	M_C-A	M_D-ABC	M_D-AB	M_ABC-D        M_AB-D	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6ABC	theta_7AB	tau_5ABCD	tau_6ABC	tau_7AB	M_A-C	M_C-A	M_D-ABC	M_D-AB	M_ABC-D        M_AB-D > variance
for ((reps=1;reps<=${maxReps};reps++));
do 
	mean1=$(grep 'S.D' rep${reps}_1/infOut | tail -n 1 | awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' )
	mean2=$(grep 'S.D' rep${reps}_2/infOut | tail -n 1 | awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' )
	echo $reps $mean1 $mean2 >> variance
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6ABC	theta_7AB	tau_5ABCD	tau_6ABC	tau_7AB	M_A-C	M_C-A	M_D-ABC	M_D-AB	M_ABC-D        M_AB-D	theta_1A	theta_2B	theta_3C	theta_4D	theta_5ABCD	theta_6ABC	theta_7AB	tau_5ABCD	tau_6ABC	tau_7AB	M_A-C	M_C-A	M_D-ABC	M_D-AB	M_ABC-D        M_AB-D > ESS
for ((reps=1;reps<=${maxReps};reps++));
do 
	mean1=$(grep ESS rep${reps}_1/infOut | tail -n 1 | awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' )
	mean2=$(grep ESS rep${reps}_2/infOut | tail -n 1 | awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $reps $mean1 $mean2 >> ESS
done
