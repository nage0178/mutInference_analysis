#!/bin/bash
#SBATCH --partition=high2
#SBATCH --account=brannalagrp
#SBATCH --job-name=t2mut_VHigh
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-50
#SBATCH --time=2-0:00:00
#SBATCH --output=log/%A.%a.out
#SBATCH --mem=12GB

rep=$((SLURM_ARRAY_TASK_ID))

cd rep${rep}_1


maxLocus=100
cd rep${rep}_1
for ((locus=1;locus<=$maxLocus;locus++));
do
	if [[ ! -s 2out$locus ]]; then
		#echo $locus >> notFinished
		../../../MutAnce ${locus}.ctl &> 2out${locus} 
	fi
done
cd ../
wait 
