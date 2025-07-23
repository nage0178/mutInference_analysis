#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=MutNumSamples
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-20
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --time=5-0:00:00
#SBATCH --output=log/%A.%a.out


num=$((SLURM_ARRAY_TASK_ID))
dir=$(head -$num runsMut |tail -n 1 |  awk '{print $1}' )
focal=$(head -$num runsMut |tail -n 1 |  awk '{print $2}' )


cd $dir
# Only start the analysis on jobs that finished
# need to check convergence first
	if [[ -f FigTree.tre ]]; then

		MutAnce L${focal}.ctl &> out${focal}
	fi

wait;


#1-900
