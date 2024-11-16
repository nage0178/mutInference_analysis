#!/bin/bash


maxLength=10000
reps=30
seed=1

echo {1..30}/{1000,5000,10000}_{1,2} > runDir
sed "s/loci\&length = 1 10000/loci\&length = 500 5000/g" simulate.ctl | grep -v printlocus > simulateNonFocal.ctl

for ((rep=1;rep<=reps;rep++))
do

	echo rep $rep
	mkdir ${rep}
	cd ${rep}

	for focal in {1..10}
	do
		echo Locus $focal
		numMut=0

		# If no mutations, change seed and re-run until have mutations 
		while  [ $numMut == 0 ] 
		do
			
			# Update the seed, run the simulation
			sed "s/seed = 1/seed = ${seed}/g" ../simulate.ctl > simulate_${focal}.ctl
			sed -i "s/seqfile = simulate_IM.txt/seqfile = simulate_IM_${focal}.txt/g" simulate_${focal}.ctl
			sed -i "s/treefile = simulate_trees.txt/treefile = simulate_trees_${focal}.txt/g" simulate_${focal}.ctl

			~/bpp/src/bpp --simulate simulate_${focal}.ctl &> simOut_${focal}
			((seed=seed+1))
			mv mig.txt mig_${focal}.txt

			# Finds first variable site. Checks there is only one mutation at the site
			for site in $(grep Locus simOut_${focal} | awk '{print $4}' | sed 's/,//g')
			do

				# Checks site is polymorphic
				firstSite=$(tail -n +5 simulate_IM_${focal}.txt | awk '{{for(i=2;i<=NF;i++){printf("%s", $i)}}; printf("\n")}' | awk -v  i=$site '{ print substr( $0, i, 1 ) }' | grep -E 'A|T|G|C' | uniq | wc | awk '{print $1}')

				# Checks only one mutation
				if [ $firstSite != 1 ]; then
					numMut=$(grep -E "Locus:\s+1,\sSite:\s$site," simOut_${focal} | wc | awk '{print $1}')
					if [ $numMut = 1 ]; then 
					echo Site $site
						break;
					fi	
				fi


			done

		done

		# Maybe you should save focal mutation number

		# This is the length of the section of the alignment
		((charFirst=10001-site))
		((charSecond=site-1))
		
		# Reorder whole alignment so that the first polymorphic site is first in the alignment
		awk '{{for(i=2;i<=NF;i++){printf("%s", $i)}}; printf("\n")}' simulate_IM_${focal}.txt | awk -v  i=$site -v j=$charFirst '{if (NR < 5) {print $1 $2} else { print substr( $0, i, j ) }}' | sed 's/\t//g'> beginAlign
                awk '{{for(i=2;i<=NF;i++){printf("%s", $i)}}; printf("\n")}' simulate_IM_${focal}.txt | awk -v  i=$charSecond  '{if (NR < 5){printf "\n"} else { print substr( $0, 1, i ) }}' > endAlign
		paste <(cut -f1 -d " " simulate_IM_${focal}.txt) <(cut -f 1 beginAlign)  > 10000_align_${focal}.txt 
		paste -d "" <(cut -f 1,2 10000_align_${focal}.txt) <(cut -f 1 endAlign) > 10000_${focal}.txt 

	done

	# Simulate non-focal loci
	sed "s/seed = 1/seed = ${seed}/g"  ../simulateNonFocal.ctl > simulateNonFocal.ctl
	~/bpp/src/bpp --simulate simulateNonFocal.ctl &> simOut
	((seed=seed+1))

	# Prepare alignments with different sequence lengths
	for length in 1000 5000 $maxLength 
	do
		# Makes two directories for each length for the replicate MCMCs
		mkdir ${length}_{1,2}

		rm -f seq_${length}.txt

		for focal in {1..10}
		do
			# Change the length of the sequences and add to sequence file
			awk -v i=$length -F "\t" '{{print $1 "\t" substr($2, 1, i)}; printf("\n")}' 10000_${focal}.txt >> seq_${length}.txt
		done

		# Change loci length to match phylip format
		sed -i "s/10000/$length/g" seq_${length}.txt

		# Add non-focal loci
		cat simulate_IM.txt >> seq_${length}.txt 

		# Make control files with alignments names and seeds
		sed "s/simulate_IM.txt/seq_${length}.txt/g" ../inference.ctl > ${length}_1/inference.ctl
		sed "s/simulate_IM.txt/seq_${length}.txt/g" ../inference.ctl | sed "s/seed = 1/seed = 2/g" > ${length}_2/inference.ctl
	done
	cd ../

done

