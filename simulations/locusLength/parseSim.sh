echo rep,length,locus,site,time,base,pop,mean_time,time_25,time_975,popA,popB,popC,popAB,popABC,mutA,mutC,mutG,mutT > summary

for ((rep=1;rep<=30;rep++));
do
	cd ${rep}

	for length in 1000 5000 10000
	do
		cd ${length}_1

		for ((locus=1;locus<=10;locus++));
		do
		 
			if [[ -f FigTree.tre ]]; then

		#		site=1
				siteCol=2
				#siteCol=$(grep site out${locus} | awk -v var="$site"  '{for (i=1;i<=NF;i++) { if ($i == var) {  print i } } } ' )
		
				# Time
				time=$(grep "mean_time" out${locus} | awk -v col="$siteCol" '{ print $col }')
		
				# Credible set
				time25=$(grep "1_mut_02.5_HPD" out${locus} | awk -v col="$siteCol" '{ print $col }')
				time975=$(grep "1_mut_97.5_HPD" out${locus} | awk -v col="$siteCol" '{ print $col }')
		
				# Pop 
				popA=$(grep -w "1_mut_pop_A" out${locus} | awk -v col="$siteCol" '{ print $col }')
				popB=$(grep -w "1_mut_pop_B" out${locus} | awk -v col="$siteCol" '{ print $col }')
				popC=$(grep -w "1_mut_pop_C" out${locus} | awk -v col="$siteCol" '{ print $col }')
				popAB=$(grep -w "1_mut_pop_AB" out${locus} | awk -v col="$siteCol" '{ print $col }')
				popABC=$(grep -w "1_mut_pop_ABC" out${locus} | awk -v col="$siteCol" '{ print $col }')

				# base
				mutA=$(grep -w "1_mut_mutation_A" out${locus} | awk -v col="$siteCol" '{ print $col }')
				mutC=$(grep -w "1_mut_mutation_C" out${locus} | awk -v col="$siteCol" '{ print $col }')
				mutG=$(grep -w "1_mut_mutation_G" out${locus} | awk -v col="$siteCol" '{ print $col }')
				mutT=$(grep -w "1_mut_mutation_T" out${locus} | awk -v col="$siteCol" '{ print $col }')
				 

				# Finds true history of locus
				simSum=$(grep Locus: ../simOut_${locus} | awk '{print $4 $6 $8 $10}' | head -1)
				#simSum=$(grep Locus: ../simOut_${locus} | awk '{print $2 $4 $6 $8 $10}' | head -1)
				echo $simSum
		
				echo ${rep},${length},${locus},${simSum},${time},${time25},${time975},${popA},${popB},${popC},${popAB},${popABC},${mutA},${mutC},${mutG},${mutT} >> ../../summary
			fi
				
		
		done
		cd ../
	done
	cd ../
done
