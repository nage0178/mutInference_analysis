#!/bin/bash


reps=30
#seed=1

tr -d '\n'  < outPrep | sed 's/Sample/\nSample/g' | sed 's/Site/ Site/g' |sed 's/Freqs/ Freqs/g' | sed 's/Locus/\nLocus/g' | sed 's/rep/\nrep/g' | grep -v Sample > siteNumbers

for ((rep=1;rep<=reps;rep++))
do

	cd ${rep}

	# Prepare alignments with different sequence lengths
	for numSample in 10 100 200 
	do
		cd ${numSample}_1

		# For each of the 10 focual loci
		for focal in {1..10}
		do
			# Generate control files
			sed "s/1/${focal}/g" ../../mutInf.ctl > L${focal}.ctl
			sed -i "s/simulate_IM.txt/..\/seq_${numSample}.txt/g" L${focal}.ctl

			# Specify the SNP of interest
			site=$(grep "Locus ${focal} " ../../siteNumbers | head -${rep}  | tail -n 1 | awk '{print $4}')
			sed -i "s/site = 2/site = ${site}/g" L${focal}.ctl

		done
		cd ../

	done
	cd ../

done

