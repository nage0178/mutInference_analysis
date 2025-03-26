# Seed
seed=$1

# Recombination rate
if [ "$2" == "high" ]; then
	recomb=0.000000125
else
	recomb=0.0000000125
fi

# Length
length=$3
rep=$4
rep_high=$5

# Simulate with python
if [[ "$locus" -lt  11  && "$2" == "high" ]]; then
	python3 ../../sim_coal.py $seed $recomb $length $rep $rep_high > l${rep_high}/mig.txt
else
	python3 ../../sim_coal.py $seed $recomb $length $rep  > ${rep}_mig.txt
	if [[ "$rep" == 10 ]]; then
	#	 awk -v RS=Locus_rep -v rep=$rep '{print > ("l" rep "/mig"  NR ".txt")}' ${rep}_mig.txt
		tail -n +2 ${rep}_mig.txt | awk -v RS=Locus_rep  '{print > ("l" NR "/mig.txt")}' 
	else
		((index=rep+10))
		tail -n +2 ${rep}_mig.txt | awk -v RS=Locus_rep  '{print > ("l" NR + 10 "/mig.txt")}' 
	fi
fi

