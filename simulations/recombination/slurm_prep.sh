#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=prepRecomb
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-120
#SBATCH --time=3-0:00:00
#SBATCH --mem=8G  
#SBATCH --output=log/%A.%a.out


#line=$((SLURM_ARRAY_TASK_ID))
#num=$(head -$line notDone |tail -n 1)
num=$((SLURM_ARRAY_TASK_ID))
cmd=$(head -$num start | tail -n 1 | awk  '{for (i=2; i<=NF; i++) print $i}')
dir=$(head -$num start | tail -n 1 | awk '{print $1}')
#rep=$(head -$num start | tail -n 1 | awk  '{print $6}')

#echo $num >> testing
module load python
module load gsl
source sim/bin/activate

cd $dir
#echo ../../prepLocus.sh $cmd >> ../../test 
../../prepLocus.sh $cmd &> outPrep$rep

wait; 

#array=1-390
