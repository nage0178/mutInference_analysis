args = commandArgs(trailingOnly = TRUE)
 if(length(args) != 1) {
   stop("Incorrect number of arguements")
 } else {
   file <- args[1]
 }

data <- read.table(file, header = TRUE)
avg <- mean(data$allele_age)
library(bayestestR)
interval <- hdi(data$allele_age)
cat(paste(avg,interval$CI_low,interval$CI_high, sep =","))

