# -H 1pIU is the first haplotype, 
# -H 2pIu is the second haplotype
# -s is the sample
# the chr11 has to match the naming of the sequences in the fasta file
#NC_000022.11 (36253133..36267525) 

rm -rf pigm_gene*
for length in 1000 5000 10000
do
	Rscript pigm_coords.R $length > gene_file_$length
	mkdir pigm_gene_$length
	for line in $(cat gene_file_${length})
	do
		gene=$(echo $line | awk -F , '{print $1}')
		coords=$(echo $line | awk -F , '{print $2}')
		chr=$(echo ${coords} | awk -F : '{print $1}')
		echo $gene $coords $chr
	
		samtools faidx ../TGP/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa $coords > pigm_gene_${length}/${gene}_ref.txt
		
		#orignal
		bcftools norm ../TGP/VCF/1kGP_high_coverage_Illumina.${chr}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz -f ../TGP/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa -r $coords > pigm_gene_${length}/${gene}.vcf
		bgzip -f pigm_gene_${length}/${gene}.vcf && tabix pigm_gene_${length}/${gene}.vcf.gz
		
		
		for name in $(cat AsEuAfrNoChildLong.txt)
		do
			echo $name
			cat pigm_gene_${length}/${gene}_ref.txt |bcftools consensus --regions-overlap 2 -H 1pIU -s ${name} pigm_gene_${length}/${gene}.vcf.gz | sed "s/>/>${name}_1_/" > pigm_gene_${length}/${gene}_${name}_1  
			cat pigm_gene_${length}/${gene}_ref.txt |bcftools consensus --regions-overlap 2 -H 2pIU -s ${name} pigm_gene_${length}/${gene}.vcf.gz | sed "s/>/>${name}_2_/" > pigm_gene_${length}/${gene}_${name}_2  
		                                                                                                  
		done
		
		
		for name in $(cat AsEuAfrNoChildLong.txt) 
		do
			cat pigm_gene_${length}/${gene}_${name}_1 >> pigm_gene_${length}/${gene}_msa.txt
			cat pigm_gene_${length}/${gene}_${name}_2 >> pigm_gene_${length}/${gene}_msa.txt
		
		done
		
		# Using plus strand only
		#tr -d '\n' <  APOL1_msa.txt | sed 's/>/\n>/g' |sed 's/5227071/5227071\n/g'| tail -n +2 > APOL1_msa_noSpace.txt
		#echo >> APOL1_msa_noSpace.txt
		#cat msa_noSpace.txt | while read L; do if [[ $L =~ ^'>' ]]; then echo $L; else echo $L | rev | tr "ATGCatgc-" "TACGtacg-" ; fi ; done  > msa_final.txt
		
		mafft pigm_gene_${length}/${gene}_msa.txt >  pigm_gene_${length}/${gene}_msa_align.txt
	
	done
done
