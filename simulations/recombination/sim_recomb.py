import msprime
import tskit
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import sys

seed = int(sys.argv[1])
rate_r = float(sys.argv[2])
length = int(sys.argv[3])

tskit.set_print_options(max_lines = 1000000)

theta_A   = 0.00049
theta_B   = 0.00044
theta_C   = 0.0021
theta_AB  = 0.000087
theta_ABC = 0.00061
mu_year   = pow(10, -9)
g         = 20
mu_g      = mu_year * g 

tau_AB    = 0.000024
tau_ABC   = 0.00047

tau_AB_gen  = tau_AB  / (mu_year * g)
tau_ABC_gen = tau_ABC / (mu_year * g)

N_ABC = theta_ABC / (4 * mu_g)
N_AB  = theta_AB  / (4 * mu_g)
N_A   = theta_A   / (4 * mu_g)
N_B   = theta_B   / (4 * mu_g)
N_C   = theta_C   / (4 * mu_g)

demography = msprime.Demography()
demography.add_population(name="ABC",     initial_size = N_ABC)
demography.add_population(name="AB",      initial_size = N_AB )
demography.add_population(name="A",       initial_size = N_A  )
demography.add_population(name="B",       initial_size = N_B  )
demography.add_population(name="C_old",   initial_size = N_C  )
demography.add_population(name="C_young", initial_size = N_C  )
demography.add_population(name="C_extra", initial_size = N_C  )
demography.add_population_split(time=  tau_AB_gen, derived=["C_young", "C_extra"], ancestral="C_old")
demography.add_population_split(time=  tau_AB_gen, derived=["A", "B"], ancestral="AB")
demography.add_population_split(time= tau_ABC_gen, derived=["AB", "C_old"], ancestral="ABC")

# Check units and time direction
# https://tskit.dev/msprime/docs/stable/demography.html#sec-demography
# So, the migration rate of lineages from j to k is the proportion of population j that is replaced by offspring of individuals in population k, per generation (since this is the probability that the lineage we are following happens to have a parent in k).

# bpp rates
# Expected number of migrants (forward in time) from A to B = M_AB = N_B * M_AB
mig_A_B  =  0.15
mig_B_A  =  0.05
mig_A_C  =  0.12
mig_C_A  =  0.1
mig_B_C  =  1.5
mig_C_B  =  0.36
mig_AB_C =  5.0
mig_C_AB =  0.61

prop_A_B  = mig_A_B  / N_B
prop_B_A  = mig_B_A  / N_A
prop_A_C  = mig_A_C  / N_C
prop_C_A  = mig_C_A  / N_A
prop_B_C  = mig_B_C  / N_C
prop_C_B  = mig_C_B  / N_B
prop_AB_C = mig_AB_C / N_C
prop_C_AB = mig_C_AB / N_AB
#print(prop_A_B)
#print(prop_B_A)
#print(prop_AB_C)

# Source to destination backward in time, forward in time dest to source
# Proportion in source replaced by dest forward in time
demography.set_migration_rate(source="A", dest="B", rate=prop_B_A )
demography.set_migration_rate(source="B", dest="A", rate=prop_A_B )

demography.set_migration_rate(source="A", dest="C_young", rate=prop_C_A)
demography.set_migration_rate(source="C_young", dest="A", rate=prop_C_A)

demography.set_migration_rate(source="B", dest="C_young", rate=prop_C_B)
demography.set_migration_rate(source="C_young", dest="B", rate=prop_B_C)

demography.set_migration_rate(source="AB", dest="C_old", rate=prop_C_AB)
demography.set_migration_rate(source="C_old", dest="AB", rate=prop_AB_C)

# Cited in Zhu et al 2022- r = 0.37 cM/Mb  or 1.13 cM/Mb
# rho = 4Nr 
ts = msprime.sim_ancestry(
    samples=[
        msprime.SampleSet(10, population="A", time= 0),
        msprime.SampleSet(10, population="B", time= 0),
        msprime.SampleSet(10, population="C_young", time= 0),
    ],
    # r: the recombination rate per generation per base pair.
    recombination_rate = rate_r, 
    #sequence_length = 100000,
    sequence_length = length,
    demography=demography,
    record_migrations=True,
    model = "hudson",
    ploidy=2,
    random_seed=seed)

node_dict = {}
f_int = open("interval.txt", 'w')
for tree in ts.trees():
    f_int.write(f"Tree {tree.index} covers {tree.interval}\n")
    #print(f"Tree {tree.index} covers {tree.interval}")
    for n_id in tree.nodes():
        node_dict.update({n_id:"n" + str(n_id)})
    f = open("t_"+ str(tree.index)+  ".nwk", 'w')
    f.write(tree.as_newick(node_labels = node_dict))
    f.close()
    node_dict.clear()
    
f_int.close()
#tree = ts.first()


#print(demography)
print(ts.tables.migrations)
