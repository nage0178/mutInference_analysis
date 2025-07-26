echo recomb,rep,locus,generations,mean,var  > check_tsdate_results.txt
for dir in {mid,high}/rep{1..30}/l{1..10}
do
  echo $dir 
  cd $dir

  # <reviewer>: extract true age in generations
  mut=$(awk '{print $6 }' mutInfo | sed 's/,//g')

  anc=$(awk '{ print $14 }' siteInfo)
  anc_2=$(awk '{print $10 }' mutInfo)

  # <reviewer>: extract position (bp) of focal site
  pos=$(awk '{ print $10 }' siteInfo)
  #pos=$(awk '{ print $12 }' siteInfo)

  # <reviewer>: find mutation from inferred tree sequence with same position
  # (relies on output from 'tsinfer_date_bugfix.py') and output posterior mean
  # and variance
  state=$(grep "^${pos} " outTsMutation_bugfix | awk '{print $4 }')

  site=$(awk '{ print $10 }' siteInfo)
  states=$(bcftools view seq.vcf.gz | grep -v "#" | grep -n $site | awk  '{print $4 " " $5}')

  echo $dir $mut anc1 $anc anc_2 $anc_2 both $states tsdate $state >> ../../../check_tsdate_results.txt

  cd ../../../
done
sed -i 's/ /,/g' check_tsdate_results.txt
sed -i 's/\//,/g' check_tsdate_results.txt

# Check by hand the the last value is always on of the first ones
# The first two are from the vcf file, the last one is from tsdate output
awk -F , '{print $10 " " $11 " " $13 }' check_tsdate_results.txt  | sort |uniq
