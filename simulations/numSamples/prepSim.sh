#!/bin/bash

# Make sure you want the minLength to be the sequence length for all the other sequences

reps=30
length=5000 # This has to be equal to the simulated length
seed=10000
Rseed=1
minCount=250
sample=1000
sed "s/$sample $sample $sample/20 20 20/g" simulate.ctl | sed "s/1 5000/500 5000/g" | sed "s/simple.Imap.txt/nonFocal.Imap.txt/"|  grep -v printlocus > simulateNonFocal.ctl

echo {1..30}/{10,100,200}_{1,2} > runDir
for ((rep=1;rep<=reps;rep++))
do
	echo rep $rep

	mkdir ${rep}
	cd ${rep}
	
	rm -f sites

	# Run the simulations for the focal loci independently
	for focal in {1..10}
	do
	
		echo Locus $focal
		pass=0
	
		# If frequency is too low 
		while [ $pass != 1 ] 
		do
			
			# Update the seed, run the simulation
			sed "s/seed = 1/seed = ${seed}/g" ../simulate.ctl > simulate_${focal}.ctl
			sed -i "s/seqfile = simulate_IM.txt/seqfile = simulate_IM_${focal}.txt/g" simulate_${focal}.ctl
			sed -i "s/treefile = simulate_trees.txt/treefile = simulate_trees_${focal}.txt/g" simulate_${focal}.ctl
			~/bpp/src/bpp --simulate simulate_${focal}.ctl &> simOut_$focal
			mv mig.txt mig_${focal}.txt
	
			((seed=seed+1))

			tail -n +5 simulate_IM_${focal}.txt | awk '{{for(i=2;i<=NF;i++){printf("%s", $i)}}; printf("\n")}' > tmp_align


			# Loop through sites that had a simulated mutation to loop for focal sites
			for site in $(grep Locus simOut_${focal} | awk '{print $4}' | sed 's/,//g')
			do

				awk -v  i=$site '{ print substr( $0, i, 1 ) }' tmp_align | grep -E 'A|T|G|C' > sitePattern
				firstSite=$(cat sitePattern | uniq -c | wc | awk '{print $1}')
				#echo $site $firstSite

				# If there polymorphic site
				if [ $firstSite != 1 ]; then

					# Checks there is a single mutation
					numMut=$(grep -E "Locus:\s+1,\sSite:\s$site," simOut_${focal} | wc | awk '{print $1}')
					if [ $numMut = 1 ]; then 
						
						# Check frequencies in population A
						popAcount=$(head -$sample sitePattern | sort |uniq -c)
						Abase1=$(echo $popAcount | awk '{print $1}')
						Abase2=$(echo $popAcount | awk '{print $3}')
						if [ -z "$Abase1" ];
						then
							Abase1=0
						fi

						if [ -z "$Abase2" ];
						then
							Abase2=0
						fi

						if (( Abase1 > minCount )) && (( Abase2 > minCount )); then
							echo Site $site
							echo Freqs $Abase1 $Abase2
							echo $rep $focal $site >> sites
							pass=1
							break;
						fi


						# Check the frequencies in population B
						((headCount=sample*2))
						popBcount=$(head -$headCount sitePattern |tail -n $sample | sort |uniq -c)

						Bbase1=$(echo $popBcount | awk '{print $1}')
						Bbase2=$(echo $popBcount | awk '{print $3}')
						if [ -z "$Bbase1" ];
						then
							Bbase1=0
						fi

						if [ -z "$Bbase2" ];
						then
							Bbase2=0
						fi

						if (( Bbase1 > minCount )) && (( Bbase2 > minCount )); then
							echo Site $site
							echo Freqs $Bbase1 $Bbase2
							echo $rep $focal $site >> sites
							pass=1
							break;
						fi

						# Check the frequencies in population C
						popCcount=$(tail -n $sample sitePattern | sort |uniq -c)
						Cbase1=$(echo $popCcount | awk '{print $1}')
						Cbase2=$(echo $popCcount | awk '{print $3}')
						if [ -z "$Cbase1" ];
						then
							Cbase1=0
						fi

						if [ -z "$Cbase2" ];
						then
							Cbase2=0
						fi

						if (( Cbase1 > minCount )) && (( Cbase2 > minCount )); then
							echo Site $site
							echo Freqs $Cbase1 $Cbase2
							echo $rep $focal $site >> sites
							pass=1
							break;
						fi

					fi	
				fi



			done
		done
	done
	
	# simulate non-focal loci
	sed "s/seed = 1/seed = ${seed}/g" ../simulateNonFocal.ctl > simulateNonFocal.ctl
	~/bpp/src/bpp --simulate simulateNonFocal.ctl &> simOut

	rm -f seq_${numSample}.txt

	# Prepare alignments with different sequence lengths
	for numSample in 10 100 200 
	do
		for focal in {1..10}
		do
			checkPoly=1
			while [ $checkPoly == 1 ] 
			do 
				echo Sample locus $focal subsample $numSample
				# Randomly select sequences for each focal loci
				Rscript ../sample.R $Rseed $numSample $sample > samples_${focal}_$numSample
				((Rseed=Rseed+1))

				# Check for polymorphism
				sitePoly=$(grep "$rep $focal " sites | awk '{print $3}')

				checkPoly=$(grep -w -f samples_${focal}_$numSample simulate_IM_${focal}.txt | awk  '{{for(i=2;i<=NF;i++){printf("%s", $i)}}; printf("\n")}' | awk -v  i=$sitePoly '{ print substr( $0, i, 1 ) }' |  uniq | wc | awk '{print $1}')

			done

			((totalseq=numSample*3))

			# Add sequences to alignment in phylip format
			echo $totalseq 5000 >> seq_${numSample}.txt
			grep -w -f samples_${focal}_$numSample simulate_IM_${focal}.txt >> seq_${numSample}.txt

		done	

		# Add non-focal loci to alignment
		cat simulate_IM.txt >> seq_${numSample}.txt

		mkdir ${numSample}_{1,2}

		# Make control files with alignments names and seeds
		sed "s/simulate_IM.txt/seq_${numSample}.txt/g" ../inference.ctl | sed "s/20 20 20/$numSample $numSample ${numSample}/g" > ${numSample}_1/inference.ctl
		sed "s/simulate_IM.txt/seq_${numSample}.txt/g" ../inference.ctl | sed "s/20 20 20/$numSample $numSample ${numSample}/g"  | sed "s/seed = 1/seed = 2/g" > ${numSample}_2/inference.ctl

		if [ $numSample != 10 ]; then
			echo scaling = 1 >> ${numSample}_1/inference.ctl
			echo scaling = 1 >> ${numSample}_2/inference.ctl
		fi
	done
	cd ../

done
