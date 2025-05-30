path=~/relate/
rm -r relate
mkdir relate
cd relate
N=$(awk '{ print $1 * 2 }'  ../N_est)
${path}/bin/RelateFileFormats \
                 --mode ConvertFromVcf \
                 --haps seq.haps \
                 --sample seq.sample \
                 -i ../seq

${path}/bin/RelateFileFormats \
                 --mode RemoveNonBiallelicSNPs \
                 --haps seq.haps \
		 -o seq_biallelic

${path}/bin/Relate \
      --mode All \
      -m 2.00e-8 \
      -N ${N} \
      --haps seq_biallelic.haps \
      --sample seq.sample \
      --map ../../../../relate/map.example \
      --seed 1 \
      -o relate 
