means <- read.table("~/mutInference_analysis/simulations/locusLength/means", header =TRUE)
stdev <- read.table("~/mutInference_analysis/simulations/locusLength/variance", header =TRUE)
ESS <-   read.table("~/mutInference_analysis/simulations/locusLength/ESS", header =TRUE)

numVar <- 15
t <- matrix(0, nrow = dim(means)[1], ncol = numVar)
N <- 500
for (i in 2:16) {
  denom <- (stdev[,i]^2 + stdev[,i+numVar]^2)/2
  t[,i - 1] <-  (means[,i] - means[,i+numVar]) / (denom^(1/2) * (2 /N)^(1/2))
  i = i + 1
}

cutOff <- qt(p = .05/2, df = 2*N -2, lower.tail= FALSE)
converge <- rep(0, dim(means)[1])
for (i in 1:dim(means)[1]) {
  converge[i] <-  all(t[i, ] < cutOff)
}

convergeESS <- rep(0, dim(ESS)[1])
for (i in 1:dim(ESS)[1]) {
  convergeESS[i] <-  all(ESS[i, 2:(dim(ESS)[2])] > 200)
}

cat(means[which(converge*convergeESS == 0),1])
