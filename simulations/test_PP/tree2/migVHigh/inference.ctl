seed = 1

seqfile =  simulate_IM.txt
Imapfile = simple.Imap.txt
outfile =  outfile.txt
mcmcfile = mcmc.txt

# fixed number of species/populations 
*speciesdelimitation = 0

# fixed species tree

species&tree = 4  A B C D
                  5 5 5 5
		  (((A , B ), C) , D);


# phased data for population
phase =   0 0 0 0 

# use sequence likelihood
usedata = 1

nloci = 100
clock = 1
model = HKY

# invgamma(a, b) for root tau & Dirichlet(a) for other tau's
tauprior = gamma 5 50000
thetaprior = gamma 2 2000

# finetune for GBtj, GBspr, theta, tau, mix, locusrate, seqerr
finetune =  1: 5 0.001 0.001  0.001 0.3 0.33 1.0  

# MCMC samples, locusrate, heredityscalars, Genetrees
print = 1 0 0 1 1  
burnin = 100000
sampfreq = 8
nsample = 500000

printlocus = 100 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 

migprior = 1.5 3
migration = 6
A C 
C A 
AB D 
D AB 
ABC D 
D ABC 

