cd ../
echo recomb,rep,locus,generations,lower,upper  > relate/relate_results.txt
for dir in {mid,high}/rep{1..30}/l{1..10}
do
	cd $dir
	site=$(awk '{ print $10 }' siteInfo)
	mut=$(awk '{print $6 }' mutInfo)
	branch_range=$(awk -v var=$site -F ";" '{ if ( var == $2 ) print $0  }' relate/relate.mut | awk -F ";" '{ print $9 "\t" $10 }')
	echo $dir ${mut}$branch_range >> ~/mutInference_analysis/simulations/recombination/relate/relate_results.txt
	cd ../../../
done
sed -i 's/\//,/g' relate/relate_results.txt
sed -i 's/ /,/g' relate/relate_results.txt
