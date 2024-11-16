#!/bin/bash


reps=30
#seed=1

for ((rep=1;rep<=reps;rep++))
do

	cd ${rep}

	# Prepare alignments with different sequence lengths
	for length in 1000 5000 10000
	do
		cd ${length}_1

		for focal in {1..10}
		do
			sed "s/1/${focal}/g" ../../mutInf.ctl > L${focal}.ctl
			sed -i "s/simulate_IM.txt/..\/seq_${length}.txt/g" L${focal}.ctl
			sed -i "s/simulate_IM.txt/..\/seq_${length}.txt/g" L${focal}.ctl
			sed -i "s/site = 2/site = 1/g" L${focal}.ctl

		done
		cd ../

	done
	cd ../

done

