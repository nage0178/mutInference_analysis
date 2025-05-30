#col=$(head -1 mid/rep1/l1/arg1.allele_age.bed)
echo recomb,rep,locus,generations,mean,lower_HPD,upper_HPD  > arg_results.txt
module load R
for dir in {mid,high}/rep{1..30}/l{1..10}
do
	cd $dir
	site=$(awk '{ print $10 }' siteInfo)
	mut=$(awk '{print $6 }' mutInfo)
	head -3 arg1.allele_age.bed | tail -n 1 | sed 's/#//g' >  allele_age_focal.bed
	grep $site arg1.allele_age.bed >> allele_age_focal.bed
	sum=$(Rscript ../../../findArgStats.R allele_age_focal.bed | tail -n 1)

	
	echo ${dir},${mut}$sum >> ~/mutInference_analysis/simulations/recombination/arg_results.txt
	cd ../../../
done
sed -i 's/\//,/g' arg_results.txt
sed -i 's/ /,/g' arg_results.txt
