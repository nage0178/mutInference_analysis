path=~/relate/
mkdir relate
cd relate
N=$(cat N_est)
${path}/bin/RelateFileFormats \
                 --mode ConvertFromVcf \
                 --haps seq.haps \
                 --sample seq.sample \
                 -i ../seq

${path}/bin/RelateFileFormats \
                 --mode RemoveNonBiallelicSNPs \
                 --haps seq.haps \

${path}/bin/Relate \
      --mode All \
      -m 2.00e-8 \
      -N ${N} \
      --haps seq_biallelic.haps \
      --sample seq.sample \
      --map ../../../../map.example \
      --seed 1 \
      -o relate 
