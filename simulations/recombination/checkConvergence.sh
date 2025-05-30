#!/bin/bash


echo rep	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C > means

for rep in {mid,high}/rep{1..30}/
do 
	mean1=$(grep mean ${rep}1/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	mean2=$(grep mean ${rep}2/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $rep $mean1 $mean2 >> means
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C > variance

for rep in {mid,high}/rep{1..30}/
do 
	mean1=$(grep 'S.D' ${rep}1/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	mean2=$(grep 'S.D' ${rep}2/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	echo $rep $mean1 $mean2 >> variance
done

echo rep	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C	theta_1A	theta_2B	theta_3C	theta_4ABC	theta_5AB	tau_4ABC	tau_5AB	M_A-B	M_A-C	M_BA	M_B-C	M_C-A	M_C-B	M_C-AB	M_AB-C > ESS

for rep in {mid,high}/rep{1..30}/
do 
	mean1=$(grep ESS ${rep}1/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	mean2=$(grep ESS ${rep}2/output* | tail -n 1 | awk '{for(i=2;i<=16;i++) printf $i" "; print ""}' )
	#echo $mean1
	echo $rep $mean1 $mean2 >> ESS
done

grep -v log  means > tmpmeans
grep -v  -E '/$' variance > tmpvariance
grep -v  -E '/$' ESS > tmpESS

awk '{ if (NF == 31) print $0 }' variance  > tmpvariance
awk '{ if (NF == 31) print $0 }' ESS  > tmpESS
mv tmpmeans means
mv tmpvariance variance
mv tmpESS ESS
