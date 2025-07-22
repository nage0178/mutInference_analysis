
i=$1
file=AsEuAfrNoChild.txt
j=1

echo $i

# For each locus with coordinates coords
for coords in $(cat coords${i}.txt) 
do

	# Creates a vcf files for just the region of the coordinates for the samples
	samtools faidx ~/dataHome2/TGP/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa ${coords} > ref/chr${i}_${j}.fa

	bcftools view norm_TGP_${i}.vcf.gz -r ${coords} -S $file  > vcf_small/chr${i}_${j}.vcf
	bgzip -f vcf_small/chr${i}_${j}.vcf && tabix vcf_small/chr${i}_${j}.vcf.gz


	finish=1

	# For every individual in the sample
	for sample in $(cat $file) 
	do
		# Get the first of the phased sequences and check if the sequence is empty
		echo $sample $j $coords
		cat ref/chr${i}_${j}.fa |bcftools consensus --regions-overlap 2 -H 1pIU -s ${sample}  vcf_small/chr${i}_${j}.vcf.gz  2> error1_${i} | sed "s/>/>${sample}_1_/"  > seq1

		empty=$(wc -l seq1 |  awk '{print $1}') 
		if  [[ $empty -eq 1 ]]; then
			echo emtpy sequence
			rm msa/msa_chr${i}_${j}.fa

			rm vcf_small/chr${i}_${j}.vcf.gz
			rm vcf_small/chr${i}_${j}.vcf.gz.tbi

			(( j = j - 1 ))
			finish=0
			break

		fi

		# Add the sequence to be aligned
		cat seq1 >>  msa/msa_chr${i}_${j}.fa

		# Get the second of the phased sequences and check if the sequence is empty
		cat ref/chr${i}_${j}.fa |bcftools consensus --regions-overlap 2 -H 2pIU -s ${sample}  vcf_small/chr${i}_${j}.vcf.gz 2>> error1_${i}| sed "s/>/>${sample}_2_/" > seq2

		empty=$(wc -l seq2 |  awk '{print $1}') 
		if  [[ $empty -eq 1 ]]; then
			echo emtpy sequence
			rm msa/msa_chr${i}_${j}.fa

			rm vcf_small/chr${i}_${j}.vcf.gz
			rm vcf_small/chr${i}_${j}.vcf.gz.tbi

			(( j = j - 1 ))
			finish=0
			break

		fi


		# Add the sequence to be aligned
	       	cat seq2 >>  msa/msa_chr${i}_${j}.fa

		if grep -vq Applied error1_${i}
		then
			cat error1_${i} >> errors_${i}
		fi

		if grep -q Symbolic error1_${i}
		then
			echo not ok
			grep Symbolic error1_${i}
			rm msa/msa_chr${i}_${j}.fa

			rm vcf_small/chr${i}_${j}.vcf.gz
			rm vcf_small/chr${i}_${j}.vcf.gz.tbi

			(( j = j - 1 ))
			finish=0

			break
		fi 



	done
	

	if [[ $finish -eq 1 ]]; then
		# Realign sequences
		mafft msa/msa_chr${i}_${j}.fa >  msa/msa_chr${i}_${j}_align.fa 
		wait

		gaps=$(tr -d '\n' < msa/msa_chr${i}_${j}_align.fa | sed 's/>/\n>/g' | tail -n+2 | awk -F"-" '{print NF-1}'  | sort -n | tail -1 )

		echo $gaps
		if [[ $gaps -gt 199 ]]; then
			echo $i $j gaps $gaps
			rm msa/msa_chr${i}_${j}.fa
			rm vcf_small/chr${i}_${j}.vcf.gz
			rm vcf_small/chr${i}_${j}.vcf.gz.tbi
			continue
		fi 
	fi
	(( j = j + 1))

	
	if [ $j -gt 100 ]; then
		echo 100 $i
		break
	fi
done
