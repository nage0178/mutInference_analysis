#!/bin/bash

module load vcftools
vcftools --window-pi 1000000 --gzvcf seq.vcf.gz
theta=$(tail -n 1 out.windowed.pi |awk '{print $5}')
N=$(awk -v var1=$theta 'BEGIN { print  ( var1 / 8 * 10^8) }')
echo $N > N_est

