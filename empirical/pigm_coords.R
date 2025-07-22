

#TYR,chr11:89177875-89182874
#ASIP,chr20:34264345-34269344
#OCA2,chr15:27988127-27993126
#MATP,chr5:33949088-33954087
#MCIR,chr16:89918862-89920972
#SLC24A5,chr15:48131787-48136786
#
#11:89178528 & 11:89177875-89295759 & 11:89177875-89182874
#20:34269192 & 20:34186493-34269344 & 20:34264345-34269344
#15:27990627 & 15:27719008-28099315 & 15:27988127-27993126
# 5:33951588 &  5:33944623-33984693 &  5:33949088-33954087
#16:89919532 & 16:89918862-89920972 & 16:89918862-89920972
#16:89920200 & 16:89918862-89920972 & 16:89918862-89920972
#15:48134287 & 15:48120990-48142672 & 15:48131787-48136786
#
#TYR  & 
#ASIP & 
#OCA2 & 
#MATP & 
#MC1R & 
#MC1R & 
#SLC24A5

args = commandArgs(trailingOnly=TRUE)
length <- as.integer(args[1])
#length <- 10000S


coords <- matrix(c(89178528,89177875,89295759,11,
		   34269192,34186493,34269344,20,
		   27990627,27719008,28099315,15,
		   33951588,33944623,33984693,5,
		   89919532,89918862,89920972,16,
		   89920200,89918862,89920972,16,
		   48134287,48120990,48142672,15), nrow = 7, byrow = TRUE)
rownames(coords) <- c("TYR", 
  "ASIP", 
  "OCA2", 
  "MATP", 
  "MC1R", 
  "MC1R", 
  "SLC24A5")

colnames(coords) <- c("location", "start", "end", "chrom")

# Check if the start location would be outside of the gene if the SNP of interest were in the middle
start <- coords[,1]-(length / 2)
for (i in 1:7) {
  if (start[i] < coords[i, 2]) {
    start[i] <-  coords[i, 2]
  }
}

# Check if the end location would be outside of the gene if the SNP of interest were in the middle
end <- start + (length -1)
for (i in 1:7) {
  if (end[i] > coords[i, 3]) {
    end[i] <-  coords[i, 3]
    start[i] <- coords[i, 3] - (length -1)
  }
}

# Check if the gene is shorter than the desired length
for (i in 1:7) {
  if (coords[i, 3] - coords[i,2] < length) {
    start[i] <- coords[i,2]
    end[i] <- coords[i,3]
  }
}


# Print the coordinates to use
for (i in 1:7) {
  if (i != 5) {
    cat(paste(rownames(coords)[i], ",chr", coords[i,4], ":", start[i], "-", end[i], "\n", sep = ""))
  }
}

