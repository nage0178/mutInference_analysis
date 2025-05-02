echo recomb,rep,locus,generations,mean,var  > tsdate_results.txt
for dir in {mid,high}/rep{1..30}/l{1..10}
do
	echo $dir 
	cd $dir
	site=$(awk '{ print $10 }' siteInfo)
	mut=$(awk '{print $6 }' mutInfo | sed 's/,//g')


	num=$(bcftools view seq.vcf.gz | grep -v "#" | grep -n $site | awk -F :  '{print $1}')

	id=$(grep -v "#" outTsMutation | sed  's/[^ -~]/ /g' | sed 's/,//g' | awk -v siteIndex=$num '{ if ( $2 == siteIndex ) {print $1} }')
	
	meanVar=$(grep ^${id} outTsMutation | awk '{print $2 " " $3}')

	echo $dir $mut $meanVar >> ../../../tsdate_results.txt

	cd ../../../
done
sed -i 's/ /,/g' tsdate_results.txt
sed -i 's/\//,/g' tsdate_results.txt
