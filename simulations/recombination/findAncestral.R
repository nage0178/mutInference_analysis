library(ape)
#file <- "~/mutInference_analysis/simulations/recombination/mid/rep1/l11/seq.fa"
args = commandArgs(trailingOnly = TRUE)
 if(length(args) != 1) {
   stop("Incorrect number of arguements")
 } else {
   file <- args[1]
 }
seq <- read.dna(file, as.matrix = T, form="fasta", as.character = T)
ancestral <- rep("N", dim(seq)[2])
for (i in 1:dim(seq)[2]) {
  bases <- table(sort(seq[,i]))
  if (length(bases) >1) {
    #print(bases)
    ancestral[i] <- toupper((names(bases)[which(bases == max(bases))]))
  } 
}
cat(paste(">ancestral\n"), sep="")
cat(paste(ancestral, sep = ""), sep = "")
cat(paste("\n"), sep="")
