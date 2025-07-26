import zarr
import tsinfer
import tsdate
import sys
import tskit
import numpy as np

# Note: fasta must be sorted by population

vcf_file = sys.argv[1]

vdata = tsinfer.VariantData(vcf_file , ancestral_state="variant_AA", sequence_length=1000001) 

inferred_ts = tsinfer.infer(vdata)
# <reviewer>: script is missing the `tsdate.process_ts` step here, but
# shouldn't matter for this sequence length / sample size
sim_ts = inferred_ts.simplify()

output_ts, fit = tsdate.date(sim_ts, mutation_rate=2e-8, return_fit=True)

# <reviewer>: print out position of site, posterior mean, and posterior variance
site_already_visited = np.full(output_ts.num_sites, False)
print("pos mean var")
for t in output_ts.trees():
    for m in t.mutations():
        if m.edge != tskit.NULL:  # below root
            site = m.site
            # <reviewer>:
            # print out first mutation at site (there could be multiple
            # mutations if multiallelic or mapped on to trees by parsimony),
            # but those will typically be very few
            if not site_already_visited[site]:
                pos = int(output_ts.sites_position[site])
                mean = m.metadata["mn"]
                var = m.metadata["vr"]
                deriv = m.derived_state
                site_already_visited[site] = True
                print(f"{pos} {mean} {var} {deriv}")


