#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=numSamples
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-180
#SBATCH --cpus-per-task=16
#SBATCH --time=35-0:00:00
#SBATCH --output=log/%A.%a.out


num=$((SLURM_ARRAY_TASK_ID))
dir=$(awk -v i=$num '{print $i}' runDir)


cd $dir
if [[ ! -f FigTree.tre ]]; then

	#echo $dir >> ../../notDone
#	~/bpp/src/bpp --cfile inference.ctl --theta_mode 3 &> output &
fi
wait;
