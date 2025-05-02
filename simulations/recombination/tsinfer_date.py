import zarr
import tsinfer
import tsdate
import sys
import tskit
import pandas as pd

pd.set_option('display.max_rows', None)  # or 1000
# Note: fasta must be sorted by population

tskit.set_print_options(max_lines = 1000000)
vcf_file = sys.argv[1]

vdata = tsinfer.VariantData(vcf_file , ancestral_state="variant_AA", sequence_length=1000001) 

inferred_ts = tsinfer.infer(vdata)
sim_ts = inferred_ts.simplify()
print(f"Inferred a genetic genealogy for {inferred_ts.num_samples} (haploid) genomes")

output_ts, fit = tsdate.date(sim_ts, mutation_rate=2e-8, return_fit =True)
print(output_ts.tables.mutations)
posteriors_df = pd.DataFrame(fit.mutation_posteriors())
print(posteriors_df)

