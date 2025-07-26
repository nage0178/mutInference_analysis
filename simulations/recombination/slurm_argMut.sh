#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=argweaver
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-600
#SBATCH --time=1-0:00:00
#SBATCH --mem=4G  
#SBATCH --output=log/%A.%a.out


#Only doing medium to start
num=$((SLURM_ARRAY_TASK_ID))
dir=$(awk -v i=$num '{print $i}' locusDir )



cd $dir

module load python
module load bedops
../../../est_mut_arg.sh &> outArgMut

wait; 

