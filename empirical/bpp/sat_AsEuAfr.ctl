seed = 1

seqfile =  ../../AsEuAfr_seq.txt
Imapfile = ../../AsEuAfr.imap.txt
outfile =  outfile.txt
mcmcfile = mcmc.txt

# fixed number of species/populations 
*speciesdelimitation = 0

# fixed species tree

species&tree = 3 LWK GBR CHS 
                   40 40  40 
		  (LWK, (GBR, CHS));


# phased data for population
phase =   0 0 0 

# use sequence likelihood
usedata = 1

nloci = 1006 
clock = 1
model = HKY

# invgamma(a, b) for root tau & Dirichlet(a) for other tau's
tauprior = gamma 2.5 40000
thetaprior = gamma 2.5 5000

# finetune for GBtj, GBspr, theta, tau, mix, locusrate, seqerr
finetune =  1: 5 0.001 0.0001  0.0001 0.3 0.33 1.0


# MCMC samples, locusrate, heredityscalars, Genetrees
print = 1 0 0 1 1  
burnin = 200000
sampfreq = 8
nsample = 500000
threads = 32 1 1
printlocus = 6 1 2 3 4 5 6 
checkpoint = 800000 800000

migprior = 1.5 3 
migration = 8
GBR LWK
LWK GBR 
CHS LWK
LWK CHS
GBR CHS
CHS GBR
LWK GBRCHS
GBRCHS LWK 
