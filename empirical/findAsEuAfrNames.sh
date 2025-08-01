rm -f AsEuAfrNoChild.txt
rm -f AsEuAfrNoChildLong.txt
rm -f AsEuAfr.imap.txt

# Remove parent child trios from the dataset 
grep "0 0 [1-2]$" pedigree.txt | awk -F' ' '{print $1}' > noChildren.txt

samBig=20
samSmall=10

# Draws individuals from each of the populations to be included in the analysis removing parent/child trios
for name in LWK GBR CHS
do
	grep ${name} igsr-1000-30x-samples.txt | awk '{print $1}'  > ${name}_ancestry.txt
	cat ${name}_ancestry.txt  noChildren.txt  | sort |uniq -c |grep "      2" | awk '{print $2}' > ${name}NoChild.txt

	# Draws a sample of size $samSmall individuals to be included in the analysis
	Rscript shuffle.R ${name}NoChild.txt $samSmall 1 >> AsEuAfrNoChild.txt
	tail -n $samSmall AsEuAfrNoChild.txt | sed "s/$/_1 ${name}/" >> AsEuAfr.imap.txt
	tail -n $samSmall AsEuAfrNoChild.txt | sed "s/$/_2 ${name}/" >> AsEuAfr.imap.txt

	# Draws a sample of size $samBig individuals to be included in the analysis
	Rscript shuffle.R ${name}NoChild.txt $samBig 2 >> AsEuAfrNoChildLong.txt
	tail -n $samBig AsEuAfrNoChildLong.txt | sed "s/$/_1 ${name}/" >> AsEuAfr.imap.txt
	tail -n $samBig AsEuAfrNoChildLong.txt | sed "s/$/_2 ${name}/" >> AsEuAfr.imap.txt
done
sort AsEuAfr.imap.txt | uniq > tmp_imap

# Creates the imap file required for bpp
mv tmp_imap AsEuAfr.imap.txt

