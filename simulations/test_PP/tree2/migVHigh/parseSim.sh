#echo locus,site,time,base,pop > simSummary
#grep Locus: simOut | awk '{print $2 $4 $6 $8 $10}' >> simSummary

echo rep,locus,site,time,base,pop,mean_time,time_25,time_975,popA,popB,popC,popD,popAB,popABC,popABCD,mutA,mutC,mutG,mutT > summary2

for ((rep=1;rep<=50;rep++));
do
	if [[ $rep -eq 23 ]]; then
		continue
	fi 
	cd rep${rep}_1
	echo locus,site,time,base,pop > simSummary2
	grep Locus: simOut | awk '{print $2 $4 $6 $8 $10}' >> simSummary2


	for ((locus=1;locus<=100;locus++));
	do
	
		for site in $(grep "^${locus}," simSummary2 | awk -F , '{print $2}')
		do
			#check if uniq
			uniq=$(grep "^${locus},${site}," simSummary2 | wc -l )
			if [ "$uniq" !=  1 ];
			then
				echo $uniq $locus $site
				continue
				
			fi
	
			#echo $site
			siteCol=$(grep site 2out${locus} | awk -v var="$site"  '{for (i=1;i<=NF;i++) { if ($i == var) {  print i } } } ' )
		#	echo $siteCol
			passSiteCol=$(echo $siteCol | wc -w | awk '{print $1}' )
	
			# Time
			time=$(grep "mean_time" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
	
			# Credible set
			time25=$(grep "1_mut_02.5_HPD" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			time975=$(grep "1_mut_97.5_HPD" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
	
			# Pop 
			popA=$(grep -w "1_mut_pop_A" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			popB=$(grep -w "1_mut_pop_B" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			popC=$(grep -w "1_mut_pop_C" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			popD=$(grep -w "1_mut_pop_D" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			popAB=$(grep -w "1_mut_pop_AB" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			popABC=$(grep -w "1_mut_pop_ABC" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			popABCD=$(grep -w "1_mut_pop_ABCD" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			# base
			mutA=$(grep -w "1_mut_mutation_A" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			mutC=$(grep -w "1_mut_mutation_C" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			mutG=$(grep -w "1_mut_mutation_G" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			mutT=$(grep -w "1_mut_mutation_T" 2out${locus} | awk -v col="$siteCol" '{ print $col }')
			 
			# add info from simSummary to line, append to file
			simSum=$(grep "^${locus},${site}," simSummary2)
			if  ((passSiteCol==1)); then
	
				echo ${rep},${simSum},${time},${time25},${time975},${popA},${popB},${popC},${popD},${popAB},${popABC},${popABCD},${mutA},${mutC},${mutG},${mutT} >> ../summary2
			fi 
			
		done
	
	done
	cd ../
done
