
for recomb in mid  high
do
	cd $recomb

	for rep in {1..30}
	do
		cd rep${rep}

		# loop for loci
		for locus in {1..10}
		do
			cd l${locus}
			Rscript ../../../findAncestral.R seq.fa > ancestral_seq.fa
			python3 ../../../makeVCF.py seq.fa seq.vcf ancestral_seq.fa
			bgzip -f seq.vcf && tabix seq.vcf.gz
			cd ../
		done
		cd ../
	done
	cd ../
done
