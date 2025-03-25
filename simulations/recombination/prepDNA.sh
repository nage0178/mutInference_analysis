
seed=1
for dir in {mid,high}/rep{1..30}/l{1..510}
do
	echo $dir
	cd $dir

	sed 's/;/:0.0;/g' trees.nwk > trees_edit.nwk
	split -l 1 -d trees_edit.nwk -a 8 trees/
	
	tree=$(ls trees/* | wc -w)
	# Make alignments
	for ((i=0;i<tree;i++))
	do
		((j=i+1))
		treeName=$(ls trees/* | head -$j | tail -n 1)
		((line=i+1))
		interval=$(head -$line interval.txt | tail -n 1)
		start=$(echo $interval | sed 's/=/ /g' | sed 's/\./ /g' | awk '{print $5}')
		end=$(echo $interval | sed 's/=/ /g' | sed 's/\./ /g' | awk '{print $8}')
		((base=end-start))
	
		../../../../../dnaSim/dna_sim -t ${treeName} -o seq${i} -u 0.00000002 -s $seed -f 0.28:0.23:0.22:0.27-1.0:8.0:1.0:1.0:8.0:1.0 -b $base &> mut_${i}.txt 
		((seed=seed+1))
	
		# Need to sort the files so the sequences are in the same order
		if [[ "$i" == 0 ]]; then
			sed 's/^/\t/g' seq${i}.fa| tr -d '\n' | sed 's/\t>/\n>/g' |  sort  -t n -g -k 2 | sed 's/\t/\n/g' | tail -n +2 > ${i}_sort.fa
		else 
			sed 's/^/\t/g' seq${i}.fa| tr -d '\n' | sed 's/\t>/\n>/g' |  sort  -t n -g -k 2 | sed 's/\t/\n/g' | sed 's/>.*//g' | tail -n +2 > ${i}_sort.fa
		fi
	done
	
	# Combine all the sequence files
	rm -f lists*
	rm -f merge*
	
	ls -1 *_sort.fa | sort -n | split -l 1000 -d - lists
	for list in lists*; do paste $(cat $list) > merge${list##lists}; done
	paste merge* | sed 's/\t//g' > seq.fa 

	cd ../../../
	
done
