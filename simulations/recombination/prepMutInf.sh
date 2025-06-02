#!/bin/bash


reps=30
#seed=1

# Prepare alignments with different sequence lengths
for recomb in mid high
do
	cd $recomb

	for ((rep=1;rep<=reps;rep++))
	do

		cd rep${rep}/1


		for focal in {1..10}
		do
			sed "s/1/${focal}/g" ../../../mutInf.ctl > L${focal}.ctl

			sed -i "s/site = 2502/site = 2501/g" L${focal}.ctl

		done
		cd ../../

	done
	cd ../

done

