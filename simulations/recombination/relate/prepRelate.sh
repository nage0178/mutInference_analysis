path=~/relate_v1.2.2_x86_64_static/
${path}/bin/RelateFileFormats \
                 --mode ConvertFromVcf \
                 --haps example.haps \
                 --sample example.sample \
                 -i ../test 

echo step 2

${path}/bin/RelateFileFormats \
                 --mode RemoveNonBiallelicSNPs \
                 --haps example.haps \
                 -o example_biallelic

${path}/bin/Relate \
      --mode All \
      -m 2.00e-8 \
      -N 30000 \
      --haps example_biallelic.haps \
      --sample example.sample \
      --map map.example \
      --seed 1 \
      -o example
