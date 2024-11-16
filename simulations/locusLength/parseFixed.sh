echo rep,length,locus,site,time,base,pop,mean_time,time_25,time_975,popA,popB,popC,popAB,popABC,mutA,mutC,mutG,mutT > summaryFixed

for ((rep=1;rep<=30;rep++));
do
	cd ${rep}

	length=inf
	for ((locus=1;locus<=10;locus++));
	do
	 

	#	site=1
		siteCol=2
		#siteCol=$(grep site out${locus} | awk -v var="$site"  '{for (i=1;i<=NF;i++) { if ($i == var) {  print i } } } ' )
	
		# Time
		time=$(grep "mean_time" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
	
		# Credible set
		time25=$(grep "1_mut_02.5_HPD" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		time975=$(grep "1_mut_97.5_HPD" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
	
		# Pop 
		popA=$(grep -w "1_mut_pop_A" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		popB=$(grep -w "1_mut_pop_B" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		popC=$(grep -w "1_mut_pop_C" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		popAB=$(grep -w "1_mut_pop_AB" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		popABC=$(grep -w "1_mut_pop_ABC" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')

		# base
		mutA=$(grep -w "1_mut_mutation_A" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		mutC=$(grep -w "1_mut_mutation_C" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		mutG=$(grep -w "1_mut_mutation_G" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		mutT=$(grep -w "1_mut_mutation_T" outFixed${locus} | awk -v col="$siteCol" '{ print $col }')
		 

		# Finds true history of locus
		simSum=$(grep Locus: simOut_${locus} | awk '{print $4 $6 $8 $10}' | head -1)
		#simSum=$(grep Locus: ../simOut_${locus} | awk '{print $2 $4 $6 $8 $10}' | head -1)
		echo $simSum
	
		echo ${rep},${length},${locus},${simSum},${time},${time25},${time975},${popA},${popB},${popC},${popAB},${popABC},${mutA},${mutC},${mutG},${mutT} >> ../summaryFixed
			
	
	done
	cd ../
done
