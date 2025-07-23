#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=locusLength
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-180
#SBATCH --cpus-per-task=16
#SBATCH --time=32-0:00:00
#SBATCH --output=log/%A.%a.out


num=$((SLURM_ARRAY_TASK_ID))
dir=$(awk -v i=$num '{print $i}' runDir)


cd $dir
	~/bpp/src/bpp --cfile inference.ctl --theta_mode 3 &> output &
wait;
