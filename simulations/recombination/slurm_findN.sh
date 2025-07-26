#!/bin/bash
#SBATCH --partition=high2
#SBATCH --account=brannalagrp
#SBATCH --job-name=findN
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-600
#SBATCH --time=5:00
#SBATCH --output=log/%A.%a.out


#line=$((SLURM_ARRAY_TASK_ID))
#num=$(head -$line notDone |tail -n 1)
num=$((SLURM_ARRAY_TASK_ID))
dir=$(awk -v i=$num '{print $i}' locusDir )

cd $dir

module load vcftools
vcftools --window-pi 1000000 --gzvcf seq.vcf.gz
theta=$(tail -n 1 out.windowed.pi |awk '{print $5}')
N=$(awk -v var1=$theta 'BEGIN { print  ( var1 / 8 * 10^8) }')
echo $N > N_est

wait; 

