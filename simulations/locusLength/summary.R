library(ggplot2)
library(forcats)
library(reshape)
library(plotrix)
library(ggpubr)

file <- "~/mutInference_analysis/simulations/locusLength/summary"
file1 <- "~/mutInference_analysis/simulations/locusLength/summaryFixed"

sum <- read.csv(file, header =TRUE)
sumFixed <- read.csv(file1, header=TRUE)
sum <- rbind(sum, sumFixed)

##### Times
# Coverage for time
coverage <- which((sum$time_25 < sum$time) * (sum$time_975 > sum$time) == 1)
length(coverage) / dim(sum)[1]

sum_1000 <- sum[which(sum$length == 1000),]
sum_5000 <- sum[which(sum$length == 5000),]
sum_10000<- sum[which(sum$length == 10000),]
sum_inf<- sum[which(is.infinite(sum$length)),]

# Coverage 
coverage <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
coverage[1,2] <- length( which((sum_1000$time_25 < sum_1000$time) * (sum_1000$time_975 > sum_1000$time) == 1)) / dim(sum_1000)[1]
coverage[2,2] <- length( which((sum_5000$time_25 < sum_5000$time) * (sum_5000$time_975 > sum_5000$time) == 1)) / dim(sum_5000)[1]
coverage[3,2] <- length( which((sum_10000$time_25 < sum_10000$time) * (sum_10000$time_975 > sum_10000$time) == 1)) / dim(sum_10000)[1]
coverage[4,2] <- length( which((sum_inf$time_25 < sum_inf$time) * (sum_inf$time_975 > sum_inf$time) == 1)) / dim(sum_inf)[1]

{
pdf("~/mutationSim/figs/sequenceLength_SumStat.pdf", width = 6, height = 7)
par(mfrow = c(3, 2))
par(mar = c(4, 5, 1.5, .5), xaxs='i', yaxs='i')
plot(coverage, xaxt='n',  xlab = "", ylab = "coverage (time)", pch = 16, ylim =c(0,1),  xlim = c(0, 16000), yaxs="i", xaxs = "i") 
#Axis(x=c(0,15000), at = c(0, 1000, 5000, 10000, 15000), side=1, labels = c(0, 1000, 5000, 10000, expression(infinity)))
 axis.break(1, 12000, style = "slash")
 mtext("a", side = 3, line = -.5, adj = -.25, font = 2)
 

# Bias
bias <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)

bias[1,2] <- mean(sum_1000$mean_time - sum_1000$time) / (.5 * 10 ^ -9)
bias[2,2] <- mean(sum_5000$mean_time - sum_5000$time)/ (.5 * 10 ^ -9)
bias[3,2] <- mean(sum_10000$mean_time - sum_10000$time) / (.5 * 10 ^ -9)
bias[4,2] <- mean(sum_inf$mean_time - sum_inf$time) / (.5 * 10 ^ -9)

plot(bias, xaxt='n', yaxt='n', xlab = "", ylab = "bias", pch = 16 , xlim = c(0, 16000), ylim = c(-20000, 10000), yaxs="i", xaxs= "i")
#Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
Axis(x=c(-17000,8000), at = c(-20000, -10000, 0 , 10000), side=2, labels = c(-20000, -10000,  0 , 10000))
axis.break(1, 12000, style = "slash")
mtext("b", side = 3,line = -.5, adj = -.25, font = 2)


# Root mean square error
RMSE <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
RMSE[1,2] <- (mean((sum_1000$time - sum_1000$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)
RMSE[2,2] <- (mean((sum_5000$time - sum_5000$mean_time)^2))^(1/2)/ (.5 * 10 ^ -9)
RMSE[3,2] <- (mean((sum_10000$time - sum_10000$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)
RMSE[4,2] <- (mean((sum_inf$time - sum_inf$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)

plot(RMSE, xaxt='n', yaxt='n', xlab = "", ylab = "RMSE", pch = 16, ylim = c(0, 360000), xlim = c(0, 16000), yaxs="i", xaxs = "i")
#Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
Axis(x=c(0,350000), at = c(100000, 200000, 300000), side=2, labels = c(100000, 200000, 300000))
axis.break(1, 12000, style = "slash")
mtext("c", side = 3, line = -.5, adj = -.25, font = 2)

# Credible intervals
CI_size <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
#CI_size <- matrix(c(1000, 5000, 10000, Inf, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
CI_size[1,2] <- mean(sum_1000$time_975 - sum_1000$time_25)/ (.5 * 10 ^ -9)
CI_size[2,2] <- mean(sum_5000$time_975 - sum_5000$time_25)/ (.5 * 10 ^ -9)
CI_size[3,2] <- mean(sum_10000$time_975 - sum_10000$time_25)/ (.5 * 10 ^ -9)
CI_size[4,2] <- mean(sum_inf$time_975 - sum_inf$time_25)/ (.5 * 10 ^ -9)

plot(CI_size, xaxt='n',  yaxt='n', xlab = "", ylab = "size of credible interval", pch = 16, ylim = c(0, 1.1*10^6), xlim = c(0, 16000))
#Axis(x=c(0,15000), at = c(0, 1000, 5000, 10000, 15000), side=1, labels = c(0, 1000, 5000, 10000, expression(infinity)))
Axis(x=c(0,350000), at = c(0, 300000, 600000, 900000), side=2, labels = c(0, 300000, 600000, 900000))

axis.break(1, 12000, style = "slash")
mtext("d", side = 3, line = -.5, adj = -.25, font = 2)

#ggplot(sum, aes(y = mean_time, x = time)) + geom_point() + facet_grid(~length) + geom_abline(col="red") +
 # geom_errorbar(aes (ymin=time_25, ymax =time_975)) +theme_classic() + theme(aspect.ratio=1)

# Coverage 


##### Pop of origin
# mean posterior probability of most probably population
power_pop <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), nrow = 4, byrow =FALSE)
power_pop[1, 2] <- mean(apply(sum_1000[ , 11:15], 1, max))
power_pop[2, 2] <- mean(apply(sum_5000[ , 11:15], 1, max))
power_pop[3, 2] <- mean(apply(sum_10000[ , 11:15], 1, max))

sum_inf[which(is.na(sum_inf[, 11])),11] <- 0
sum_inf[which(is.na(sum_inf[, 12])),12] <- 0
sum_inf[which(is.na(sum_inf[, 13])),13] <- 0
sum_inf[which(is.na(sum_inf[, 14])),14] <- 0
sum_inf[which(is.na(sum_inf[, 15])),15] <- 0

power_pop[4, 2] <- mean(apply(sum_inf[ , 11:15], 1, max))

plot(power_pop, xaxt='n',  xlab = "sequence length", ylab = "HP population probability", pch = 16, ylim =c(0,1),  xlim = c(0, 16000), yaxs="i", xaxs = "i")
Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
axis.break(1, 12000, style = "slash")
mtext("e", side = 3, line = -.5, adj = -.25, font = 2)

##### Mutation 
power_mut <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), nrow = 4, byrow =FALSE)

power_mut[1, 2] <- mean(apply(sum_1000[ , 16:19], 1, max))
power_mut[2, 2] <- mean(apply(sum_5000[ , 16:19], 1, max))
power_mut[3, 2] <- mean(apply(sum_10000[ , 16:19], 1, max))
power_mut[4, 2] <- mean(apply(sum_inf[ , 16:19], 1, max))

plot(power_mut, xaxt='n',  xlab = "sequence length", ylab = "HP mutation probability", pch = 16, ylim =c(0,1),  xlim = c(0, 16000), yaxs="i", xaxs = "i")
Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
axis.break(1, 12000, style = "slash")
mtext("f", line = -.5, adj = -.25, font = 2)

dev.off()}

##### Coverage
# popBin <-rep(0, 11) 
# popCor <-rep(0, 11)
# sumBin <- rep(0, 11)

sum_num <- cbind(paste(sum$rep, sum$site, sum$locus,sep = "_"), sum)
colnames(sum_num)[1] <- "sim_num"
m_sum = melt(sum_num, id.vars=c("sim_num", "length", "pop"),
            measure.vars=c("popA", "popB", "popC", "popAB", "popABC"))


p_popSum <- ggplot(m_sum, aes(x = sim_num , y = value, fill = variable)) + 
  geom_bar(position="stack", stat="identity", ) + 
  ylab("Posterior Probability") + 
  scale_fill_discrete(name="Inferred\nPopulation",
                      breaks=c("popA", "popB", "popC", "popAB", "popABC"),
                      labels=c('A', 'B', 'C', 'AB', 'ABC')) + 
  facet_grid(length~fct_relevel(pop, levels = 'A', 'B', 'C', 'AB', 'ABC'), space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0)) +
  theme(axis.title.x=element_blank(), 
    axis.text.x=element_blank(), 
    axis.ticks.x=element_blank(), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank())



m_sumMut = melt(sum_num, id.vars=c("sim_num", "length", "base"),
             measure.vars=c("mutA", "mutC", "mutG", "mutT"))


p_mutSum <- ggplot(m_sumMut, aes(x = sim_num , y = value, fill = variable)) + 
  ylab("Posterior Probability") + 
  scale_fill_discrete(name="Inferred\nMutation",
                      breaks=c("mutA", "mutC", "mutG", "mutT"),
                      labels=c('A', 'C', 'G', 'T')) + 
  geom_bar(position="stack", stat="identity", ) + 
  facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0)) +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), 
        axis.ticks.x=element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

figure <- ggarrange(p_popSum, p_mutSum,  labels = c("a", "b"),
                    nrow =2, ncol = 1)
pdf("~/mutationSim/figs/sequenceLength_stackBar.pdf", width = 7, height = 10)
figure
dev.off()
