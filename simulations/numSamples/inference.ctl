seed = 1

seqfile =  ../simulate_IM.txt
Imapfile = ../simple.Imap.txt
outfile =  outfile.txt
mcmcfile = mcmc.txt


# fixed species tree

species&tree = 3 A B C
                 20 20 20  
		  ((A, B), C);


# phased data for population
phase =   0 0 0

# use sequence likelihood
usedata = 1

nloci = 510
clock = 1
model = HKY

# invgamma(a, b) for root tau & Dirichlet(a) for other tau's
tauprior = gamma 5 50000
thetaprior = gamma 2 2000

# finetune for GBtj, GBspr, theta, tau, mix, locusrate, seqerr
finetune =  1: 5 0.001 0.001  0.00001 0.3 0.33 1.0  

# MCMC samples, locusrate, heredityscalars, Genetrees
print = 1 0 0 1 1 
printlocus = 10 1 2 3 4 5 6 7 8 9 10

burnin = 100000
sampfreq = 8
nsample = 500000
threads = 16  
checkpoint = 800000 800000

migprior = 1.5 3
migration = 8
A B
B A
A C
C A
B C
C B
AB C
C AB
