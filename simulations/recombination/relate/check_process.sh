cd ../
echo recomb,rep,locus,true1,true2,inferred1,inferred2  > relate/check_relate_results.txt
# Note the true 1 and true2 may be the same or different. One of them is the true ancestral and the othe other is based on frequency. Both true 1 and true 2 must be included in the inferred states
for dir in {mid,high}/rep{1..30}/l{1..10}
do
	cd $dir
	anc=$(awk '{ print $14 }' siteInfo)
	site=$(awk '{ print $10 }' siteInfo)
	#mut=$(awk '{print $6 }' mutInfo)
	anc_2=$(awk '{print $10 }' mutInfo)
	bases=$(awk -v var=$site -F ";" '{ if ( var == $2 ) print $0  }' relate/relate.mut | awk -F ";" '{ print $11 }')
	echo $dir site1:${anc} site2:$anc_2 relate:$bases >> ~/mutInference_analysis/simulations/recombination/relate/check_relate_results.txt
	cd ../../../
done
sed -i 's/\//,/g' relate/check_relate_results.txt
sed -i 's/ /,/g' relate/check_relate_results.txt

# Check by hand all these combinations are allowed
awk -F , '{print $4 " " $5 " " $6 " " $7 }' relate/check_relate_results.txt | sort |uniq
