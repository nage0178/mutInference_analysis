#!/bin/bash

maxLocus=100
for ((rep=1;rep<=50;rep++));
do
	cd rep${rep}_1

	#awk '{ if ( NR  % 10 == 1 )   {print  } else if (NR == 1) { print }}' mcmc.txt > sub_mcmc.txt

	for ((locus=1;locus<=$maxLocus;locus++));
	do
		echo $rep $locus >> ../prep
		sed "s/1/${locus}/g" ../sub_mutInf.ctl > ${locus}.ctl 
		#sed "s/1/${locus}/g" ../mutInf.ctl > ${locus}.ctl 

		awk '{ if ( NR  % 10 == 1 )   {print  } else if (NR == 1) { print }}' locus.${locus}.sample.txt > sub_locus.${locus}.sample.txt
		
		#Files with no header
		awk '{ if ( NR  % 10 == 0 )   {print  }  }'  outfile.txt.mig.L${locus} > sub_outfile.txt.mig.L${locus}
		awk '{ if ( NR  % 10 == 0 )   {print  }  }'  outfile.txt.gtree.L${locus} > sub_outfile.txt.gtree.L${locus}
	done
	cd ../
done
wait

