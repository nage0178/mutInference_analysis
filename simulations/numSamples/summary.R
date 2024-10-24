library(ggplot2)
library(forcats)
library(reshape)
library(plotrix)

# Still not final- need to check convergence and add other three mcmcs
file <- "~/mutInference_analysis/simulations/numSamples/summary"
sum <- read.csv(file, header =TRUE)
##### Times
# Coverage for time
coverage <- which((sum$time_25 < sum$time) * (sum$time_975 > sum$time) == 1)
length(coverage) / dim(sum)[1]

sum_10 <- sum[which(sum$samples == 10),]
sum_100 <- sum[which(sum$samples == 100),]
sum_200<- sum[which(sum$samples == 200),]

# Coverage 
coverage <- matrix(c(10, 100, 200, 0, 0, 0), byrow = FALSE, nrow = 3)
coverage[1,2] <- length( which((sum_10$time_25 < sum_10$time) * (sum_10$time_975 > sum_10$time) == 1)) / dim(sum_10)[1]
coverage[2,2] <- length( which((sum_100$time_25 < sum_100$time) * (sum_100$time_975 > sum_100$time) == 1)) / dim(sum_100)[1]
coverage[3,2] <- length( which((sum_200$time_25 < sum_200$time) * (sum_200$time_975 > sum_200$time) == 1)) / dim(sum_200)[1]

{
  pdf("~/mutationSim/figs/numSamples_SumStat.pdf", width = 6, height = 7)
  par(mfrow = c(3, 2))
  par(mar = c(4, 5, 1.5, .5), xaxs='i', yaxs='i')
  plot(coverage, ylab = "coverage (time)", xaxt='n',  xlab = "", pch = 16, ylim =c(0,1),  xlim = c(0, 210), yaxs="i", xaxs = "i") 
  #Axis(x=c(0,15000), at = c(0, 1000, 5000, 10000, 15000), side=1, labels = c(0, 1000, 5000, 10000, expression(infinity)))
  mtext("a", side = 3, line = -.5, adj = -.25, font = 2)

# Bias
#bias <- matrix(c(1000, 5000, 10000, Inf, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
bias <- matrix(c(10, 100, 200, 0, 0, 0), byrow = FALSE, nrow = 3)

bias[1,2] <- mean(sum_10$mean_time - sum_10$time) / (.5 * 10 ^ -9)
bias[2,2] <- mean(sum_100$mean_time - sum_100$time)/ (.5 * 10 ^ -9)
bias[3,2] <- mean(sum_200$mean_time - sum_200$time) / (.5 * 10 ^ -9)

plot(bias,  ylab = "bias", xaxt='n',  xlab = "", pch = 16, ylim =c(-17000,8000),  xlim = c(0, 210), yaxs="i", xaxs = "i") 
#Axis(x=c(-17000,8000), at = c(-20000, -10000, 0 , 10000), side=2, labels = c(-20000, -10000,  0 , 10000))
mtext("b", side = 3, line = -.5, adj = -.25, font = 2)


# Root mean square error
RMSE <- matrix(c(10, 100, 200, 0, 0, 0), byrow = FALSE, nrow = 3)
RMSE[1,2] <- (mean((sum_10$time - sum_10$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)
RMSE[2,2] <- (mean((sum_100$time - sum_100$mean_time)^2))^(1/2)/ (.5 * 10 ^ -9)
RMSE[3,2] <- (mean((sum_200$time - sum_200$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)

plot(RMSE,  ylab = "RMSE", xaxt='n', xlab = "", pch = 16, ylim = c(0, 350000), xlim = c(0, 210), yaxs="i", xaxs = "i", yaxt='n',)
Axis(x=c(0,350000), at = c(100000, 200000, 300000), side=2, labels = c(100000, 200000, 300000))
mtext("c", side = 3, line = -.5, adj = -.25, font = 2)

# Credible intervals
CI_size <- matrix(c(10, 100, 200, 0, 0, 0), byrow = FALSE, nrow = 3)
CI_size[1,2] <- mean(sum_10$time_975 - sum_10$time_25)/ (.5 * 10 ^ -9)
CI_size[2,2] <- mean(sum_100$time_975 - sum_100$time_25)/ (.5 * 10 ^ -9)
CI_size[3,2] <- mean(sum_200$time_975 - sum_200$time_25)/ (.5 * 10 ^ -9)

plot(CI_size,  ylab = "size of credible interval", pch = 16, xlim = c(0, 210), ylim = c(0, 1.2 * 10^6), yaxs="i", xaxs = "i", xaxt='n', xlab = "")
#Axis(x=c(0,10^6), at = c(2.5 * 10^5, 5 * 10^5, 7.5 * 10^5, 10* 10^5), side=2, labels = c(2.5 * 10^5,5 * 10^5, 7.5 * 10^5, 10 * 10^5))
mtext("d", side = 3, line = -.5, adj = -.25, font = 2)

# Coverage 


##### Pop of origin
# mean posterior probability of most probably population
power_pop <- matrix(c(10, 100, 200, 0, 0, 0), nrow = 3, byrow =FALSE)

power_pop[1, 2] <- mean(apply(sum_10[ , 11:15], 1, max))
power_pop[2, 2] <- mean(apply(sum_100[ , 11:15], 1, max))
power_pop[3, 2] <- mean(apply(sum_200[ , 11:15], 1, max))

plot(power_pop, xaxt='n',  xlab = "samples", ylab = "HP population probability", pch = 16, ylim =c(0,1),  xlim = c(0, 210), yaxs="i", xaxs = "i")
Axis(x=c(0,210), at = c(10, 100, 200), side=1, labels = c(10, 100, 200))
mtext("e", side = 3, line = -.5, adj = -.25, font = 2)

##### Mutation 
power_mut <- matrix(c(10, 100, 200, 0, 0, 0), nrow = 3, byrow =FALSE)

power_mut[1, 2] <- mean(apply(sum_10[ , 16:19], 1, max))
power_mut[2, 2] <- mean(apply(sum_100[ , 16:19], 1, max))
power_mut[3, 2] <- mean(apply(sum_200[ , 16:19], 1, max))

plot(power_mut, xaxt='n',  xlab = "samples", ylab = "HP mutation probability", pch = 16, ylim =c(0,1),  xlim = c(0, 210), yaxs="i", xaxs = "i")
Axis(x=c(0,210), at = c(10, 100, 200), side=1, labels = c( 10, 100, 200))
mtext("f", side = 3, line = -.5, adj = -.25, font = 2)
dev.off()}

##### Coverage

sum_num <- cbind(paste(sum$rep, sum$site, sum$locus,sep = "_"), sum)
#sum_num <- cbind(rep(1:dim(sum)[1]), sum)
colnames(sum_num)[1] <- "sim_num"
m_sum = melt(sum_num, id.vars=c("sim_num", "samples", "pop"),
            measure.vars=c("popA","popB", "popC", "popAB", "popABC"))


p_popSum <- ggplot(m_sum, aes(x = sim_num , y = value, fill = variable)) + 
  geom_bar(position="stack", stat="identity", ) + 
  ylab("Posterior Probability") + 
  scale_fill_discrete(name="Inferred\nPopulation",
                      breaks=c("popA","popB", "popC", "popAB", "popABC"),
                      labels=c( 'A', 'B', 'C', 'AB', 'ABC')) + 
  facet_grid(samples~fct_relevel(pop, levels = 'C', 'AB', 'ABC'), space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0)) +
  theme(axis.title.x=element_blank(), 
    axis.text.x=element_blank(), 
    axis.ticks.x=element_blank(), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())



m_sumMut = melt(sum_num, id.vars=c("sim_num", "samples", "base"),
             measure.vars=c("mutA", "mutC", "mutG", "mutT"))


p_mutSum <- ggplot(m_sumMut, aes(x = sim_num , y = value, fill = variable)) + 
  ylab("Posterior Probability") + 
  geom_bar(position="stack", stat="identity", ) + 
  scale_fill_discrete(name="Inferred\nMutation",
                      breaks=c("mutA", "mutC", "mutG", "mutT"),
                      labels=c('A', 'C', 'G', 'T')) + 
  facet_grid(samples~base, space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0)) +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), 
        axis.ticks.x=element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

figure <- ggarrange(p_popSum, p_mutSum,  labels = c("a", "b"),
                    nrow =2, ncol = 1)
pdf("~/mutationSim/figs/numSamples_stackBar.pdf", width = 7, height = 10)
figure
dev.off()

# popBin <-rep(0, 11) 
# popCor <-rep(0, 11)
# sumBin <- rep(0, 11)
# 
# for (i in 1:dim(sum)[1]) {
#   index <-sum$popA[i]*100 %/% 10 +1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$popA[i] + sumBin[index]
#   if (sum$pop[i] == "A") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   index <-sum$popB[i]*100 %/% 10 + 1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$popB[i]+ sumBin[index]
#   if (sum$pop[i] == "B") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   index <-sum$popC[i]*100 %/% 10 +1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$popC[i]+ sumBin[index]
#   if (sum$pop[i] == "C") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   
#   index <-sum$popAB[i]*100 %/% 10 + 1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$popAB[i]+ sumBin[index]
#   if (sum$pop[i] == "AB") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   
#   if ("popABC" %in% colnames(sum)){
#     index <-sum$popABC[i]*100 %/% 10 +1
#     popBin[index] <- popBin[index] + 1
#     sumBin[index] <- sum$popABC[i]+ sumBin[index]
#     if (sum$pop[i] == "ABC") {
#       popCor[index] <- popCor[index] + 1
#     }
#   } 
#   
#   
# }
# popCor/popBin
# sumBin / popBin
# popBin
# 
# if ( j == 1) {
#   plot(popCor/popBin, sumBin / popBin, pch= 20, type ="o", xlab = "proportion correct in bin", ylab = "average posterior probability in bin")
#   legend(0, .95, legend=c("1", "2", "3", "4", "5"),  title = "Simulation",
#          fill = c(1, 2,3, 4, 5)
#   )
# } else {
#   lines(popCor/popBin, sumBin / popBin, pch= 20, type ="o", col = j)
# }
# 
# p <- sumBin / popBin
# 
# std<- (p /((1 -p) *popBin))^(1/2)
# 
# high <- popCor/popBin + (std  *1.96)
# low <- popCor/popBin - (std  *1.96)
# 
# low
# p
# high 
# #}
# #dev.off()
# 
# #pdf("~/mutationSim/mutation_summary.pdf")
# for (j in 1:5) {
#   file <- files[j]
#   sum <- read.csv(file, header =TRUE)
#   
#   
# popBin <-rep(0, 11) 
# popCor <-rep(0, 11)
# sumBin <- rep(0, 11)
# 
# for (i in 1:dim(sum)[1]) {
#   index <-sum$mutA[i]*100 %/% 10 +1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$mutA[i] + sumBin[index]
#   if (sum$base[i] == "A") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   index <-sum$mutC[i]*100 %/% 10 + 1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$mutC[i]+ sumBin[index]
#   if (sum$base[i] == "C") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   index <-sum$mutG[i]*100 %/% 10 +1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$mutG[i]+ sumBin[index]
#   if (sum$base[i] == "G") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
#   index <-sum$mutT[i]*100 %/% 10 +1
#   popBin[index] <- popBin[index] + 1
#   sumBin[index] <- sum$mutT[i]+ sumBin[index]
#   if (sum$base[i] == "T") {
#     popCor[index] <- popCor[index] + 1
#   }
#   
# 
# }
# if ( j == 1) {
#   plot(popCor/popBin, sumBin / popBin, pch= 20, type ="o", xlab = "proportion correct in bin", ylab = "average posterior probability in bin")
#   legend(0, .95, legend=c("1", "2", "3", "4", "5"),  title = "Simulation",
#          fill = c(1, 2,3, 4, 5)
#   )
# } else {
#   lines(popCor/popBin, sumBin / popBin, pch= 20, type ="o", col = j)
# }
# 
# }
#dev.off()
