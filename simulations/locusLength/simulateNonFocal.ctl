seed = 1

seqfile = simulate_IM.txt
treefile = simulate_trees.txt
Imapfile = simple.Imap.txt

modelparafile = parameters.txt

# fixed number of species/populations 
*speciesdelimitation = 0

# fixed species tree

species&tree = 3  A B C
                  20 20 20  
		  ((A #0.00049, B #0.00044):.000024 #.000087, C #0.0021):.00047 #.00061;


# phased data for population
phase =   0 0 0 

loci&length = 500 5000
clock = 1
locusrate =0
model = 7
basefreqs = 1 .27 .23 .28 .22
qrates = 1 8 1 1 1 1 8


migration = 8
A B  0.15
B A  0.05
A C  0.12
C A  0.1
B C  1.5
C B  0.36
AB C 5.0
C AB 0.61

