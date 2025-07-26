#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=prepDNA
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=3001-6000
#SBATCH --time=2-0:00:00
#SBATCH --output=log/%A.%a.out

num=$((SLURM_ARRAY_TASK_ID))
dir=$(head -$num prepDnaDir | tail -n 1 | awk '{print $1}')
seed=$(head -$num prepDnaDir | tail -n 1 | awk '{print $2}')


cd $dir
#echo ../../prepLocus.sh $cmd >> ../../test 
../../../prepDNA.sh $seed &> outPrepDNA

wait; 

