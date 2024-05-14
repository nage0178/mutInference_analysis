args <- commandArgs(trailingOnly=TRUE)
seed <- args[1]
numSamples <- args[2]
numTotal <- args[3]
set.seed(seed)

randSamp <- sample(1:numTotal, numSamples, replace=FALSE)
cat(paste("A^a", randSamp, sep = ""),sep = "\n")

randSamp <- sample(1:numTotal, numSamples, replace=FALSE)
cat(paste("B^b", randSamp, sep = ""),sep = "\n")

randSamp <- sample(1:numTotal, numSamples, replace=FALSE)
cat(paste("C^c", randSamp,  sep = ""),sep = "\n")
