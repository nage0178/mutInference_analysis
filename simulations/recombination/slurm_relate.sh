#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=relate
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-600
#SBATCH --time=20:00
#SBATCH --output=log/%A.%a.out


#Only doing medium to start
num=$((SLURM_ARRAY_TASK_ID))
dir=$(awk -v i=$num '{print $i}' locusDir )



cd $dir
../../../relate/runRelate.sh &> outRelate

wait; 

