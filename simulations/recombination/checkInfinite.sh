echo tmp > tmp
for i in {mid,high}/rep{1..30}/l{1..10}
do
	inf=$(tail -n +2 ${i}/allele_age_focal.bed| awk '{print $10}'  | grep 1 | wc)
	all=$(tail -n +2 ${i}/allele_age_focal.bed| awk '{print $10}'  | wc)
	cat tmp | awk -v var1="$inf" -v var2="$all" '{print var1/var2 }' 
done
