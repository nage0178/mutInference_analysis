#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=MutlocusLength
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-900
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --time=15:00:00
#SBATCH --output=log/%A.%a.out


num=$((SLURM_ARRAY_TASK_ID))
dir=$(head -$num runsMut |tail -n 1 |  awk '{print $1}' )
focal=$(head -$num runsMut |tail -n 1 |  awk '{print $2}' )


cd $dir
	if [[ -f FigTree.tre ]]; then
		MutAnce L${focal}.ctl &> out${focal}
	fi

wait;


