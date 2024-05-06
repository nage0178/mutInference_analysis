
rm -rf pigm_gene
mkdir pigm_gene
for line in $(cat gene_file)
do
	gene=$(echo $line | awk -F , '{print $1}')
	coords=$(echo $line | awk -F , '{print $2}')
	chr=$(echo ${coords} | awk -F : '{print $1}')
	echo $gene $coords $chr

	samtools faidx ~/dataHome2/TGP/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa $coords > pigm_gene/${gene}_ref.txt
	
	#orignal
	bcftools norm ~/dataHome2/TGP/VCF/1kGP_high_coverage_Illumina.${chr}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz -f ~/dataHome2/TGP/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa -r $coords > pigm_gene/${gene}.vcf
	bgzip -f pigm_gene/${gene}.vcf && tabix pigm_gene/${gene}.vcf.gz
	
	
	for name in $(cat AsEuAfrNoChildLong.txt)
	do
		echo $name
		cat pigm_gene/${gene}_ref.txt |bcftools consensus --regions-overlap 2 -H 1pIU -s ${name} pigm_gene/${gene}.vcf.gz | sed "s/>/>${name}_1_/" > pigm_gene/${gene}_${name}_1  
		cat pigm_gene/${gene}_ref.txt |bcftools consensus --regions-overlap 2 -H 2pIU -s ${name} pigm_gene/${gene}.vcf.gz | sed "s/>/>${name}_2_/" > pigm_gene/${gene}_${name}_2  
	                                                                                                  
	done
	
	
	for name in $(cat AsEuAfrNoChildLong.txt) 
	do
		cat pigm_gene/${gene}_${name}_1 >> pigm_gene/${gene}_msa.txt
		cat pigm_gene/${gene}_${name}_2 >> pigm_gene/${gene}_msa.txt
	
	done
	
	# Using plus strand only
	
	mafft pigm_gene/${gene}_msa.txt >  pigm_gene/${gene}_msa_align.txt

done
