tr -d '\n'  < outPrep | sed 's/Sample/\nSample/g' | sed 's/Site/ Site/g' |sed 's/Freqs/ Freqs/g' | sed 's/Locus/\nLocus/g' | sed 's/rep/\nrep/g' | grep -v Sample > siteNumbers

echo rep,samples,locus,site,time,base,pop,mean_time,time_25,time_975,popA,popB,popC,popAB,popABC,mutA,mutC,mutG,mutT > summary

for ((rep=1;rep<=30;rep++));
do
	cd ${rep}

	for samples in 10 100 200
	do
		cd ${samples}_1
		
		if [[ -f FigTree.tre ]]; then

		for ((locus=1;locus<=10;locus++));
		do
		 
			siteCol=2
		
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

			site=$(grep "Locus ${locus} " ../../siteNumbers | head -${rep}  | tail -n 1 | awk '{print $4}')
			simSum=$(grep Locus: ../simOut_${locus} | awk '{print $4 $6 $8 $10}' | grep "^${site},")
		
			echo ${rep},${samples},${locus},${simSum},${time},${time25},${time975},${popA},${popB},${popC},${popAB},${popABC},${mutA},${mutC},${mutG},${mutT} >> ../../summary
				
		
		done
		fi
		cd ../
	done
	cd ../
done
