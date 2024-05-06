
rm -r msa
rm -r vcf_small
rm -r ref
rm -f errors*


mkdir msa
mkdir vcf_small
mkdir ref


for i in 1 2 3 4 5 6 7 8 9 10
do
	./prepChrom_i.sh $i &> outPrep${i} 
done


wait 


rm -f AsEuAfr_seq.txt

./pigmentation_genes.sh

# Prepare format for bpp
for line in $(cat gene_file)
do
	gene=$(echo $line | awk -F , '{print $1}')

	seqNum=$(grep ">" pigm_gene/${gene}_msa_align.txt | wc -l )

	sed -i 's/_chr.*:.*/\t/' pigm_gene/${gene}_msa_align.txt
	tr -d '\n' < pigm_gene/${gene}_msa_align.txt | sed 's/>/\n^/g' | tail -n+2 > seq.txt

	seqLen=$(head -2 seq.txt | tail -n 1 | awk '{print $2}' | wc -c)
	(( seqLen = seqLen -1 ))

	echo $seqNum $seqLen >> AsEuAfr_seq.txt
	cat seq.txt >> AsEuAfr_seq.txt
	echo >> AsEuAfr_seq.txt
	echo >> AsEuAfr_seq.txt

done

for i in 1 2 3 4 5 6 7 8 9 10
do
	j=1
	for coords in $(cat ../coords${i}.txt) 
	do
		seqNum=$(grep ">" msa/msa_chr${i}_${j}_align.fa | wc -l )

		sed -i 's/_chr.*:.*/\t/' msa/msa_chr${i}_${j}_align.fa
		tr -d '\n' < msa/msa_chr${i}_${j}_align.fa | sed 's/>/\n^/g' | tail -n+2 > seq.txt

		seqLen=$(head -2 seq.txt | tail -n 1 | awk '{print $2}' | wc -c)
		(( seqLen = seqLen -1 ))

		echo $seqNum $seqLen >> AsEuAfr_seq.txt
		cat seq.txt >> AsEuAfr_seq.txt
		echo >> AsEuAfr_seq.txt
		echo >> AsEuAfr_seq.txt

		(( j = j + 1))
		if [ $j -gt 100 ]; then
			break
		fi
	done
done
