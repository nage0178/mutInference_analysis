#!/bin/bash
#SBATCH --partition=high2
#SBATCH --account=brannalagrp
#SBATCH --job-name=argweaver
#SBATCH --mail-user=aanagel@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-600
#SBATCH --time=20-0:00:00
#SBATCH --mem=2G  
#SBATCH --output=log/%A.%a.out


#Only doing medium to start
num=$((SLURM_ARRAY_TASK_ID))
dir=$(awk -v i=$num '{print $i}' locusDir )



cd $dir

done=$(tail -n 1 arg1.log | grep FINISH)
if [[ -z $done ]]
then
#	echo $dir >> ../../../argNotDone
	../../../argWeave.sh &> outArgWeaver
fi

wait; 

