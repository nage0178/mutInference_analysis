seed1=1
for recomb in mid high
do
	mkdir $recomb
	cd $recomb

	for rep in {1..2}
	do
		mkdir rep${rep}
		cd rep${rep}
	
		# loop for loci
		for locus in {1..2}
		do
			mkdir l${locus}
			cd l${locus}

			if [[ "$locus" -lt  11 ]]; then
				# Need to update
				length=1000000
			else
				length=5000
			fi
	
			../../../prepLocus.sh $seed1 $recomb $length & 
	
			((seed1=seed1+2000))
	
			cd ../
		done
		wait

		cd ../
	done
	cd ../
done
