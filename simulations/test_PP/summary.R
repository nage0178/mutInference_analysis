files <- c("~/AlPop/tree1/migLow/summary2", 
           "~/AlPop/tree1/migHigh/summary2", 
           "~/AlPop/tree2/migLow/summary2",
           "~/AlPop/tree2/migHigh/summary2", 
           "~/AlPop/tree2/migVHigh/summary2")

#files <- c("~/mutInference_analysis/tree1/migLow/summary2", 
#           "~/mutInference_analysis/tree1/migHigh/summary2", 
#           "~/mutInference_analysis/tree2/migLow/summary2",
#           "~/mutInference_analysis/tree2/migHigh/summary2", 
#           "~/mutInference_analysis/tree2/migVHigh/summary2")
pdf("~/mutationSim/popOrigin_summary.pdf")

for (j in 1:5) {
  file <- files[j]
  sum <- read.csv(file, header =TRUE)

#noNA <- which(is.na(sum[,7]) * 1 == 0)
#sum <- sum[noNA, ]

# Coverage for time
coverage <- which((sum$time_25 < sum$time) * (sum$time_975 > sum$time) == 1)
length(coverage) / dim(sum)[1]

popBin <-rep(0, 11) 
popCor <-rep(0, 11)
sumBin <- rep(0, 11)
# for (i in 1:dim(sum)[1]) {
#   for (j in 10:dim(sum)[2])
#     if (is.na(sum[i,j]) ) {
#       sum[i, j] <- 0
#     }
#}
#sum <- sum[which(nchar(sum[, 6]) != 4),]

for (i in 1:dim(sum)[1]) {
  index <-sum$popA[i]*100 %/% 10 +1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$popA[i] + sumBin[index]
  if (sum$pop[i] == "A") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$popB[i]*100 %/% 10 + 1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$popB[i]+ sumBin[index]
  if (sum$pop[i] == "B") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$popC[i]*100 %/% 10 +1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$popC[i]+ sumBin[index]
  if (sum$pop[i] == "C") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$popD[i]*100 %/% 10 +1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$popD[i]+ sumBin[index]
  if (sum$pop[i] == "D") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$popAB[i]*100 %/% 10 + 1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$popAB[i]+ sumBin[index]
  if (sum$pop[i] == "AB") {
    popCor[index] <- popCor[index] + 1
  }
  
  if ("popCD" %in% colnames(sum)){
    index <-sum$popCD[i]*100 %/% 10 +1
    popBin[index] <- popBin[index] + 1
    sumBin[index] <- sum$popCD[i]+ sumBin[index]
    if (sum$pop[i] == "CD") {
      popCor[index] <- popCor[index] + 1
    }
  }
  
  if ("popABC" %in% colnames(sum)){
    index <-sum$popABC[i]*100 %/% 10 +1
    popBin[index] <- popBin[index] + 1
    sumBin[index] <- sum$popABC[i]+ sumBin[index]
    if (sum$pop[i] == "ABC") {
      popCor[index] <- popCor[index] + 1
    }
  } 
  
  index <-sum$popABCD[i]*100 %/% 10 + 1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$popABCD[i]+ sumBin[index]
  if (sum$pop[i] == "ABCD") {
    popCor[index] <- popCor[index] + 1
  }
}
popCor/popBin
sumBin / popBin
popBin

if ( j == 1) {
  plot(popCor/popBin, sumBin / popBin, pch= 20, type ="o", xlab = "proportion correct in bin", ylab = "average posterior probability in bin")
  legend(0, .95, legend=c("1", "2", "3", "4", "5"),  title = "Simulation",
         fill = c(1, 2,3, 4, 5)
  )
} else {
  lines(popCor/popBin, sumBin / popBin, pch= 20, type ="o", col = j)
}

p <- sumBin / popBin

std<- (p /((1 -p) *popBin))^(1/2)

high <- popCor/popBin + (std  *1.96)
low <- popCor/popBin - (std  *1.96)

low
p
high 
}
dev.off()

pdf("~/mutationSim/mutation_summary.pdf")
for (j in 1:5) {
  file <- files[j]
  sum <- read.csv(file, header =TRUE)
  
  
popBin <-rep(0, 11) 
popCor <-rep(0, 11)
sumBin <- rep(0, 11)

for (i in 1:dim(sum)[1]) {
  index <-sum$mutA[i]*100 %/% 10 +1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$mutA[i] + sumBin[index]
  if (sum$base[i] == "A") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$mutC[i]*100 %/% 10 + 1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$mutC[i]+ sumBin[index]
  if (sum$base[i] == "C") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$mutG[i]*100 %/% 10 +1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$mutG[i]+ sumBin[index]
  if (sum$base[i] == "G") {
    popCor[index] <- popCor[index] + 1
  }
  
  index <-sum$mutT[i]*100 %/% 10 +1
  popBin[index] <- popBin[index] + 1
  sumBin[index] <- sum$mutT[i]+ sumBin[index]
  if (sum$base[i] == "T") {
    popCor[index] <- popCor[index] + 1
  }
  

}
if ( j == 1) {
  plot(popCor/popBin, sumBin / popBin, pch= 20, type ="o", xlab = "proportion correct in bin", ylab = "average posterior probability in bin")
  legend(0, .95, legend=c("1", "2", "3", "4", "5"),  title = "Simulation",
         fill = c(1, 2,3, 4, 5)
  )
} else {
  lines(popCor/popBin, sumBin / popBin, pch= 20, type ="o", col = j)
}

}
dev.off()
