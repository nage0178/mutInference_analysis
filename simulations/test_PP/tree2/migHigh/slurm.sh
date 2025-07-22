#!/bin/bash
#SBATCH --partition=high2
#SBATCH --account=brannalagrp
#SBATCH --job-name=100migHigh_mutHist
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-50
#SBATCH --time=10-0:00:00
#SBATCH --output=log/%A.%a.out



rep=$((SLURM_ARRAY_TASK_ID))

cd rep${rep}_1
pwd  >> ../testing 

	../../../bpp --simulate simulate.ctl &> simOut
	../../../bpp --cfile inference.ctl  &> infOut &
wait;
