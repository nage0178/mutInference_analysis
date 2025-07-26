echo recomb,rep,locus,generations,baseTrue1,baseTrue2,infBase1,infBase2  > check_arg_results.txt
# Note that both bases may not be present in baseTrue1 and baseTrue2 (one is the actual true ancestral and the other is the most frequent),  but they should always be included in infBase1 and infBase2
for dir in {mid,high}/rep{1..30}/l{1..10}
do
	cd $dir
	site=$(awk '{ print $10 }' siteInfo)
	mut=$(awk '{print $6 }' mutInfo)

	anc=$(awk '{ print $14 }' siteInfo)
	anc_2=$(awk '{print $10 }' mutInfo)

	#head -3 arg1.allele_age.bed | tail -n 1 | sed 's/#//g' >  allele_age_focal.bed
	argBase=$(grep $site arg1.allele_age.bed | head -1 | awk '{print $5 " " $6}')
#	sum=$(Rscript ../../../findArgStats.R allele_age_focal.bed | tail -n 1)

	
	echo ${dir},${mut}${anc},${anc_2},$argBase >> ~/mutInference_analysis/simulations/recombination/check_arg_results.txt
	cd ../../../
done
sed -i 's/\//,/g' check_arg_results.txt
sed -i 's/ /,/g' check_arg_results.txt

# check by hand all are acceptble 
awk -F , '{print $5 " " $6 " " $7 " "$8}' check_arg_results.txt  | sort |uniq
