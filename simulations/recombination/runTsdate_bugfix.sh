
#
#module load python/3.11.9
#source ../../../tsInferDate/bin/activate

python3 -m bio2zarr vcf2zarr convert --force seq.vcf.gz seq.vcz

python3 ../../../tsinfer_date_bugfix.py seq.vcz > outTsMutation_bugfix

#deactivate
