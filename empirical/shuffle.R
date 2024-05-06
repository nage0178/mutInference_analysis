args <- commandArgs(trailingOnly=TRUE)
file <- args[1]
numSamples <- args[2]
seed <- args[3]

samples <- read.csv(file, header = FALSE)
set.seed(seed)
randomSamp <-sample(samples[,1])[1:numSamples]
cat(randomSamp,sep = "\n")
