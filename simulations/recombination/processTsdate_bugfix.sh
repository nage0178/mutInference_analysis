echo recomb,rep,locus,generations,mean,var  > tsdate_results.txt
for dir in {mid,high}/rep{1..30}/l{1..10}
do
  echo $dir 
  cd $dir

  # <reviewer>: extract true age in generations
  mut=$(awk '{print $6 }' mutInfo | sed 's/,//g')

  # <reviewer>: extract position (bp) of focal site
  pos=$(awk '{ print $10 }' siteInfo)
  #pos=$(awk '{ print $12 }' siteInfo)

  # <reviewer>: find mutation from inferred tree sequence with same position
  # (relies on output from 'tsinfer_date_bugfix.py') and output posterior mean
  # and variance
  meanVar=$(grep "^${pos} " outTsMutation_bugfix | awk '{print $2 " " $3}')

  echo $dir $mut $meanVar >> ../../../tsdate_results.txt

  cd ../../../
done
sed -i 's/ /,/g' tsdate_results.txt
sed -i 's/\//,/g' tsdate_results.txt
