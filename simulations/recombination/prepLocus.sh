# Seed
seed=$1

# Recombination rate
if [ "$2" == "high" ]; then
	recomb=0.000000125
else
	recomb=0.0000000125
fi
# Length
length=$3

# Simulate with python
python3 ../../../sim_recomb.py $seed $recomb $length > mig.txt

tree=$(ls t_*.nwk | wc -w)
# Make alignments
for ((i=0;i<tree;i++))
do
	((line=i+1))
	interval=$(head -$line interval.txt | tail -n 1)
	start=$(echo $interval | sed 's/=/ /g' | sed 's/\./ /g' | awk '{print $5}')
	end=$(echo $interval | sed 's/=/ /g' | sed 's/\./ /g' | awk '{print $8}')
	((base=end-start))

	../../../../../dnaSim/dna_sim -t t_${i}.nwk -o seq${i} -u 0.00000002 -s $seed -f 0.28:0.23:0.22:0.27-1.0:8.0:1.0:1.0:8.0:1.0 -b $base &> mut_${i}.txt 
	((seed=seed+1))

	# Need to sort the files so the sequences are in the same order
	if [[ "$i" == 0 ]]; then
		sed 's/^/\t/g' seq${i}.fa| tr -d '\n' | sed 's/\t>/\n>/g' |  sort  | sed 's/\t/\n/g' | tail -n +2 > ${i}_sort.fa
	else 
		sed 's/^/\t/g' seq${i}.fa| tr -d '\n' | sed 's/\t>/\n>/g' |  sort  | sed 's/\t/\n/g' | sed 's/>.*//g' | tail -n +2 > ${i}_sort.fa
	fi
done

# Combine all the sequence files

rm -f lists*
rm -r merge*

ls -1 *_sort.fa | sort -n | split -l 1000 -d - lists
for list in lists*; do paste $(cat $list) > merge${list##lists}; done
paste merge* | sed 's/\t//g' > seq.fa 

