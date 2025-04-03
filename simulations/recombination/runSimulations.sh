seed1=1
for recomb in mid high
do
	mkdir $recomb
	cd $recomb

	for rep in {1..30}
	do
		mkdir rep${rep}
		cd rep${rep}
	
		mkdir  l{1..510}
		mkdir  l{1..510}/trees

		# loop for loci
		for locus in 10 500 
		do

			if [[ "$locus" -lt  11 ]]; then
				length=1000000
				#length=1000
			else
				length=5000
			fi
	
			wd=$(pwd)
		       	../../prepLocus.sh $seed1 $recomb $length $locus 
		       	echo $wd $seed1 $recomb $length $locus >> ../../start
	
			((seed1=seed1+1))
	
		#done

		cd ../
	done
	cd ../
done

