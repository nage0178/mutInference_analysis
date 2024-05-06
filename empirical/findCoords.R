#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
file <- args[1]
exons <- read.table(file, header = FALSE)
chrNum <- args[2]
set.seed(1)
minDistBetween <- 20000
seqLen <- 5000
samples <- 110

# Remove multiple entries with the same starting point
i <- 2
while(i < dim(exons)[1]) {
  if (exons[i, 2] == exons[i -1, 2]) {
    if (exons[i, 3] < exons[i - 1, 3]) {
      exons <- exons[-i, ]
    } else {
      exons <- exons[-(i -1), ]
    }
    i<- i -1
    
  }
  i <- i + 1
}

# Remove multiple entries with the same ending point
i <- 2
while(i < dim(exons)[1]) {
  if (exons[i, 3] == exons[i -1, 3]) {
    if (exons[i, 2] < exons[i - 1, 2]) {
      exons <- exons[-(i-1), ]
    } else {
      exons <- exons[-i, ]
    }
    i<- i -1
    
  }
  i <- i + 1
}

# Remove overlaps
i <- 2
while(i < dim(exons)[1]) {
  if (exons[i, 2] < exons[i -1, 3]) {
    #print(paste(exons[i, 2], exons[i-1, 3], i))
    exons[i-1, 3] <- exons[i, 3]
    exons[i-1, 4] <- exons[i-1, 3] - exons[i-1, 2] + 1
    exons <- exons[-i, ]
    i <- i -1
  }
  i <- i + 1
}

#sum((exons[,3]-exons[,2]+1 == exons[,4]))
exons <- exons[which(exons[,4] >= seqLen), ]


i <- 2
while(i < dim(exons)[1]) {

  if (exons[i, 2] - exons[i-1, 3] < minDistBetween) {
    #print(exons[(i-1):i, ])
    exons <- exons[-i, ]
    i <- i - 1
  }
  i <- i + 1
}

#exonIndex <- sort(sample(dim(exons)[1], samples, replace = FALSE))
exonIndex <- sample(dim(exons)[1], samples, replace = FALSE)


for(i in exonIndex) {
  if (exons[i, 2] - exons[i, 1] < (seqLen -1)) {
    print("problem")
  } else {
    cat(paste(chrNum, ":",  exons[i, 2], "-", exons[i, 2] + (seqLen -1) , sep = ""))
  }
cat("\n")
}

