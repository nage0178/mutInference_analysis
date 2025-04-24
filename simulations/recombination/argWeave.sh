# Region is one based and end inclusive
# M is per site per generation, assumes JC
# Time is discretized, most common to use maxtime (generations ago), 0 is present day
# n is iterations
## --region
# 23500 root tau in generation
# t is the number of time steps, run time will increase proportional to the square of this number
# they suggest 200,000 at a reasonable maxtime for humans

#module load vcftools
#vcftools --window-pi 1000000 --gzvcf seq.vcf.gz
#theta=$(tail -n 1 out.windowed.pi |awk '{print $5}')
#N=$(awk -v var1=$theta 'BEGIN { print  ( var1 / 8 * 10^8) }')
N=$(cat N_est)

rate=$(pwd | grep high)
rep=$1
if [[ "$rep" == 2 ]]; then
	seed=2
else
	seed=1
fi
if [[ "$rate" == "" ]] ; then
	~/ARGweaver/bin/arg-sample -f seq.fa -o arg$seed  -N $N -m 2e-8 -r 1.25e-8 -x $seed --maxtime 200000 -n 30000 --compress-seq 10 --overwrite
	#~/ARGweaver/bin/arg-sample -f seq.fa -o arg  -N $N -m 2e-8 -r 1.25e-8 -x 1 --maxtime 200000 -t 1000 -n 1000 --compress-seq 10 --overwrite
	#~/argweaver/bin/arg-sample -f seq.fa -o arg  -N $N -m 2e-8 -r 1.25e-8 -x 1 --maxtime 200000 -t 1000 -n 1000 --compress-seq 10 --overwrite
else 
	~/ARGweaver/bin/arg-sample -f seq.fa -o arg$seed  -N $N -m 2e-8 -r 1.25e-7 -x $seed --maxtime 200000 -n 30000 --compress-seq 10 --overwrite
	#~/argweaver/bin/arg-sample -f seq.fa -o arg  -N $N -m 2e-8 -r 1.25e-7 -x 1 --maxtime 200000 -t 1000 -n 1000 --compress-seq 10 --overwrite
fi

