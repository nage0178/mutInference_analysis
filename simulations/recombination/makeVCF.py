from Bio import AlignIO
import numpy as np
import sys

# Note: fasta must be sorted by population

f_input = sys.argv[1]
f_output = sys.argv[2]
f_ref = sys.argv[3]

# Read a single MSA from a file
alignment = AlignIO.read(f_input, "fasta")
reference = AlignIO.read(f_ref, "fasta")

align_array = np.array(alignment)
ref_array = np.array(reference)

var_site = 0
# Saves the variable sites as 1
var_sites = np.zeros([align_array.shape[1]])
for site in range(align_array.shape[1]):
    
    base = align_array[0][site]
    for seq in range(align_array.shape[0]):
        if (base != align_array[seq][site]):
            var_sites[site] = 1
            var_site = var_site + 1
            break 

# Matrix for all variable sites
vcf_mat = np.zeros([align_array.shape[0], var_site],
         dtype = np.int32)
alt = [] 
ref = [] 
alt2 = [] 
alt3 = [] 

var_sites_small = np.zeros(var_site)
index = 0
notBiallelic = np.zeros(var_site)
# For each site
for site in range(align_array.shape[1]):

    # Checkc if site is variable
    if (var_sites[site] == 1):

        # Record the reference
        base = ref_array[0][site]
        ref.append(base)

        # Record the site
        var_sites_small[index] = site

        # For each sequence
        for seq in range(align_array.shape[0]):

            # If the base does not match the reference
            if (base != align_array[seq][site]):

                if (len(alt) - 1 < index):
                    alt.append(align_array[seq][site])
                    vcf_mat[seq][index] = 1

                elif (len(alt) - 1 ==  index and alt[len(alt) - 1] == align_array[seq][site]):
                    vcf_mat[seq][index] = 1

                elif (alt[len(alt) - 1] != align_array[seq][site] and len(alt2) - 1 < index):
                    alt2.append(align_array[seq][site])
                    vcf_mat[seq][index] = 2
                    notBiallelic[index] = 1
                    
                elif (alt2[len(alt2) - 1] == align_array[seq][site] ):
                    vcf_mat[seq][index] = 2

                elif (alt2[len(alt) - 1] != align_array[seq][site] and len(alt3) - 1 < index):
                    alt3.append(align_array[seq][site])
                    vcf_mat[seq][index] = 3
                    
                elif (alt3[len(alt2) - 1] == align_array[seq][site] ):
                    vcf_mat[seq][index] = 3
                else:
                    print("More than four  alleles")
        if (len(alt2) - 1 < index):
            alt2.append("_")

        if (len(alt3) - 1 < index):
            alt3.append("_")
        index = index + 1


f= open(f_output, "w")
f.write("##fileformat=VCFv4.1\n##contig=<ID=1,length=")
f.write(str(align_array.shape[1]))
f.write(">\n##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">\n")
f.write("##INFO=<ID=AA,Number=1,Type=String,Description=\"Ancestral Allele\">\n")
f.write("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t")

for sample in range(0, align_array.shape[0], 2):
    f.write(alignment._records[sample].id)
    f.write(alignment._records[sample+1].id)

    if (sample + 2 < align_array.shape[0]):
        f.write("\t")

f.write("\n")
for site in range(index):
    f.write("1\t" + str(int(var_sites_small[site]) + 1) +  "\t.\t"  + ref[site] +  "\t" +  alt[site])
    if (notBiallelic[site] == 1):
        f.write("," + alt2[site])

        if (alt3[site] != "_"):
            f.write("," + alt3[site])
    f.write("\t.\t.\tAA=")
    f.write(ref[site])
    f.write("\tGT")

    for sample in range(0, align_array.shape[0], 2):
        f.write("\t")
        f.write(str(vcf_mat[sample][site])+ "|" + str(vcf_mat[sample + 1][site]) )
    f.write("\n")
f.close()
