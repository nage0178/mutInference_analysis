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

# Simulate with python
python3 ../../sim_coal.py $seed $recomb $length $rep  > ${rep}_mig.txt
if [[ "$rep" == 10 ]]; then
#	 awk -v RS=Locus_rep -v rep=$rep '{print > ("l" rep "/mig"  NR ".txt")}' ${rep}_mig.txt
	tail -n +2 ${rep}_mig.txt | awk -v RS=Locus_rep  '{print > ("l" NR "/mig.txt")}' 
else
	((index=rep+10))
	tail -n +2 ${rep}_mig.txt | awk -v RS=Locus_rep  '{print > ("l" NR + 10 "/mig.txt")}' 
fi

