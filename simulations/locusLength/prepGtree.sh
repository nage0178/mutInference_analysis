for rep in {1..30}
do
	echo $rep 
	cd $rep
	for locus in {1..10}
	do
		migLine=$(head -1 mig_${locus}.txt)
		gtreeLine=$(head -1 simulate_trees_${locus}.txt)
		subLine=$(head -2 ../exampleHKY.txt | tail -n 1) 
		rm -f fix_mig_${locus}.txt
		rm -f fix_gtree_${locus}.txt
		head -1 ../exampleHKY.txt > fix_sub_${locus}.txt
		
		for i in {1..10000}
		do
		
			echo $migLine >> fix_mig_${locus}.txt
			echo $gtreeLine >> fix_gtree_${locus}.txt
			echo $subLine >> fix_sub_${locus}.txt
		done
	sed -i 's/ /	/g' fix_sub_${locus}.txt
	
	done
	cd ../
done


for rep in {1..30}
do
	cd $rep

	for locus in {1..10}
	do
		# Create control files
		sed "s/1/${locus}/g" ../mutFixed.ctl > L${locus}.ctl
		sed -i "s/simulate_IM.txt/seq_1000.txt/g" L${locus}.ctl
		sed -i "s/site = 2/site = 1/g" L${locus}.ctl


	done
	cd ../
done



