# This script selects regions to use a loci for the bpp analysis 

# Separates the annotations by chromosome
grep NC_000001 GRCh38_latest_genomic.gff >  chr1.gff 
grep NC_000002 GRCh38_latest_genomic.gff >  chr2.gff 
grep NC_000003 GRCh38_latest_genomic.gff >  chr3.gff 
grep NC_000004 GRCh38_latest_genomic.gff >  chr4.gff 
grep NC_000005 GRCh38_latest_genomic.gff >  chr5.gff 
grep NC_000006 GRCh38_latest_genomic.gff >  chr6.gff 
grep NC_000007 GRCh38_latest_genomic.gff >  chr7.gff 
grep NC_000008 GRCh38_latest_genomic.gff >  chr8.gff 
grep NC_000009 GRCh38_latest_genomic.gff >  chr9.gff 
grep NC_000010 GRCh38_latest_genomic.gff >  chr10.gff 

# For each chromosome 1 through 10
for i in  1 2 3 4 5 6 7 8 9 10
do
	# Prepare the vcf files
       bcftools norm ~/dataHome2/TGP/VCF/1kGP_high_coverage_Illumina.chr${i}.filtered.SNV_INDEL_SV_phased_panel.vcf.gz -f ~/dataHome2/TGP/GRCh38/GRCh38_full_analysis_set_plus_decoy_hla.fa  > norm_TGP_${i}.vcf
       bgzip -f norm_TGP_${i}.vcf && tabix norm_TGP_${i}.vcf.gz
	
       # Find the exons in the annotations
       # The R scripts randomly selects regions that are marked as exons that are a sufficient distance from other choosen regions
       grep -n exon chr${i}.gff > exons_${i}
       awk -F "\t" '{print $4"\t" $5"\t"$5-$4+1}' exons_${i} | sort -n | uniq -c > uniq_coords_${i}
       Rscript findCoords.R uniq_coords_${i} chr${i} > coords${i}.txt
done

