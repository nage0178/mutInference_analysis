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

#{
#pdf("~/mutationSim/figs/sequenceLength_SumStat.pdf", width = 6, height = 7)
#par(mfrow = c(3, 2))
#par(mar = c(4, 5, 1.5, 4), xaxs='i', yaxs='i')
plot(coverage, xaxt='n',  xlab = "", ylab = "probability", pch = 16, ylim =c(0,1),  xlim = c(0, 16000), yaxs="i", xaxs = "i", type = "b") 
#Axis(x=c(0,15000), at = c(0, 1000, 5000, 10000, 15000), side=1, labels = c(0, 1000, 5000, 10000, expression(infinity)))
 axis.break(1, 12000, style = "slash")
 mtext("a", side = 3, line = -.5, adj = -.25, font = 2)
 
 
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
 lines(power_pop, pch = 17, type = "b", col = "blue")
 #plot(power_pop, xaxt='n',  xlab = "sequence length", ylab = "HP population probability", pch = 16, ylim =c(0,1),  xlim = c(0, 16000), yaxs="i", xaxs = "i")
 #Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
 #axis.break(1, 12000, style = "slash")
 #mtext("e", side = 3, line = -.5, adj = -.25, font = 2)

 
 ##### Mutation 
 power_mut <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), nrow = 4, byrow =FALSE)
 
 power_mut[1, 2] <- mean(apply(sum_1000[ , 16:19], 1, max))
 power_mut[2, 2] <- mean(apply(sum_5000[ , 16:19], 1, max))
 power_mut[3, 2] <- mean(apply(sum_10000[ , 16:19], 1, max))
 power_mut[4, 2] <- mean(apply(sum_inf[ , 16:19], 1, max))
 
# lines(power_mut, pch = 15, type = "b", col = "red")
 #plot(power_mut, xaxt='n',  xlab = "sequence length", ylab = "HP mutation probability", pch = 16, ylim =c(0,1),  xlim = c(0, 16000), yaxs="i", xaxs = "i")
 #Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
 #axis.break(1, 12000, style = "slash")
 #mtext("f", line = -.5, adj = -.25, font = 2)
 
 # legend("bottomleft",legend=c("coverage","HP mutation", "HP population"),
 #        text.col=c("black","red", "blue"),pch=c(16,15,17),col=c("black","red", "blue"))
 # 
# Bias
bias <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
 mu_rate <- 10^ -9
bias[1,2] <- mean(sum_1000$mean_time - sum_1000$time) /  mu_rate
bias[2,2] <- mean(sum_5000$mean_time - sum_5000$time)/ mu_rate
bias[3,2] <- mean(sum_10000$mean_time - sum_10000$time) / mu_rate
bias[4,2] <- mean(sum_inf$mean_time - sum_inf$time) / mu_rate

# plot(bias, xaxt='n', yaxt='n', xlab = "", ylab = "bias", pch = 16 , xlim = c(0, 16000), ylim = c(-20000, 10000), yaxs="i", xaxs= "i", type = "b")
# #Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
# Axis(x=c(-17000,8000), at = c(-20000, -10000, 0 , 10000), side=2, labels = c(-20, -10,  0 , 10))
# axis.break(1, 12000, style = "slash")
# mtext("b", side = 3,line = -.5, adj = -.25, font = 2)

# Credible intervals
CI_size <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
#CI_size <- matrix(c(1000, 5000, 10000, Inf, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
CI_size[1,2] <- mean(sum_1000$time_975 - sum_1000$time_25)/ mu_rate
CI_size[2,2] <- mean(sum_5000$time_975 - sum_5000$time_25)/ mu_rate
CI_size[3,2] <- mean(sum_10000$time_975 - sum_10000$time_25)/ mu_rate
CI_size[4,2] <- mean(sum_inf$time_975 - sum_inf$time_25)/ mu_rate

# par(new = TRUE)
# plot(CI_size, xaxt='n',  yaxt='n', xlab = "",  ylab = "", pch = 16, ylim = c(0, 1.1*10^6), xlim = c(0, 16000), type = "b", col = "red")
# #Axis(x=c(0,15000), at = c(0, 1000, 5000, 10000, 15000), side=1, labels = c(0, 1000, 5000, 10000, expression(infinity)))
# Axis(x=c(0,350000), at = c(0, 300000, 600000, 900000), side=4, labels = c(0, 300, 600, 900))
# mtext("size of 95% credible interval", side=4, line=3, cex = 1)
# 
# ## Add Legend
# legend("topright",legend=c("bias","size of 95% credible interval"),
#        text.col=c("black","red"),pch=c(16,15),col=c("black","red"))
# 
# #axis.break(1, 12000, style = "slash")
# mtext("b", side = 3, line = -.5, adj = -.25, font = 2)




#ggplot(sum, aes(y = mean_time, x = time)) + geom_point() + facet_grid(~length) + geom_abline(col="red") +
 # geom_errorbar(aes (ymin=time_25, ymax =time_975)) +theme_classic() + theme(aspect.ratio=1)

# Coverage 

#dev.off()}

df <- cbind(coverage, bias[,2], CI_size[, 2], power_mut[,2], power_pop[,2])
df <- as.data.frame(df)
colnames(df) <- c("length", "cov", "bias", "CI", "mut", "pop")
library(tidyverse)
library(ggbreak) 
library(patchwork)
my_df <- df %>% select(length, cov, mut, pop) %>% 
  gather(key = "variable", value = "probability", -length)
p1 <- ggplot(my_df, aes(x = length, y = probability) ) +
  labs(color = "", linetype ="", ) +
  scale_color_discrete(labels = c("coverage", "HP mutation", "HP population")) +
  scale_linetype_discrete(labels = c("coverage", "HP mutation", "HP population")) +
  scale_x_continuous( breaks = c(0, 1000, 5000, 10000, 15000), labels =c(0, 1000, 5000, 10000, expression(infinity)), position = "bottom",  sec.axis = dup_axis(breaks = NULL) ) +
  geom_line(aes(color = variable, linetype = variable)) + geom_point(aes(col = variable)) +
  scale_y_continuous(limits = c(0,1)) + 
   theme_classic() + 
  scale_x_break(c(12000, 13000)) +theme(legend.position = "bottom", axis.title.x = element_text(vjust=20), axis.title.y = element_text(hjust=.75))


df <- cbind(coverage, bias[,2], CI_size[, 2], power_mut[,2], power_pop[,2])
df <- as.data.frame(df)
colnames(df) <- c("length", "cov", "bias", "CI", "mut", "pop")
df$bias <- df$bias / 1000
df$CI <- df$CI / 1000
ylim.prim <- c(0, 1.1 * 10 ^ 6 / 1000 / 2)   # in this example, precipitation
ylim.sec <- c(-20000 / 1000 /2, 0)    # in this example, temperature

b <- diff(ylim.prim)/diff(ylim.sec)
a <- ylim.prim[1] - b*ylim.sec[1]
df <- cbind(df, (df$bias*b + a))  #cbind(df, (df$bias - a)/ b) 
colnames(df)[3] <- "original_bias"
colnames(df)[7] <- "bias"

my_df2 <- df %>% select(length, CI, bias) %>% 
  gather(key = "variable", value = `credible interval size`, -length)

p2 <- ggplot(my_df2, aes(x = length, y = `credible interval size`)) +
  geom_line(aes(color = variable, linetype = variable)) + geom_point(aes(col = variable)) +
  labs(color = "", linetype ="", ) +
  scale_y_continuous( sec.axis = sec_axis(~ (. - a)/b, name = "bias         ")) + 
  scale_x_continuous( breaks = c(0, 1000, 5000, 10000, 15000), labels =c(0, 1000, 5000, 10000, expression(infinity)), position = "bottom") + 
  theme_classic() + scale_x_break(c(12000, 13000),) +
  theme(legend.position = "bottom",  axis.title.x = element_text(vjust=20), axis.title.y = element_text(vjust=-3, hjust=.6)) 

pdf.options(reset = TRUE, onefile = FALSE)
library(grid)
library(gridExtra)
title1=text_grob("a",  face = "bold", vjust = -10)
title2=text_grob("b",  face = "bold", vjust = -10)

pdf("~/mutationSim/figs/sequenceLength_SumStat_a.pdf", width = 4, height = 3)
p1 
dev.off()
pdf("~/mutationSim/figs/sequenceLength_SumStat_b.pdf", width = 4, height = 3)
p2
dev.off()
figure <- ggarrange(p1, p1, p2, p2, labels = c("a", "b" ),
                    nrow =2, ncol = 2)

ggarrange(p1, labels = c("a" ),
          nrow =1, ncol = 1)
figure

# Root mean square error
RMSE <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
RMSE[1,2] <- (mean((sum_1000$time - sum_1000$mean_time)^2))^(1/2) / mu_rate
RMSE[2,2] <- (mean((sum_5000$time - sum_5000$mean_time)^2))^(1/2)/ mu_rate
RMSE[3,2] <- (mean((sum_10000$time - sum_10000$mean_time)^2))^(1/2) / mu_rate
RMSE[4,2] <- (mean((sum_inf$time - sum_inf$mean_time)^2))^(1/2) / mu_rate

plot(RMSE, xaxt='n', yaxt='n', xlab = "", ylab = "RMSE", pch = 16, ylim = c(0, 360000), xlim = c(0, 16000), yaxs="i", xaxs = "i")
#Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
Axis(x=c(0,350000), at = c(100000, 200000, 300000), side=2, labels = c(100000, 200000, 300000))
axis.break(1, 12000, style = "slash")
mtext("c", side = 3, line = -.5, adj = -.25, font = 2)

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


# climate <- tibble(
#   Month = 1:12,
#   Temp = c(-4,-4,0,5,11,15,16,15,11,6,1,-3),
#   Precip = c(49,36,47,41,53,65,81,89,90,84,73,55)
# )
# ylim.prim <- c(0, 180)   # in this example, precipitation
# ylim.sec <- c(-4, 18)    # in this example, temperature
# 
# b <- diff(ylim.prim)/diff(ylim.sec)
# a <- ylim.prim[1] - b*ylim.sec[1]
# 
# ggplot(climate, aes(Month, Precip)) +
#   geom_col() +
#   geom_line(aes(y = a + Temp*b), color = "red") +
#   scale_y_continuous("Precipitation", sec.axis = sec_axis(~ (. - a)/b, name = "Temperature")) +
#   scale_x_continuous("Month", breaks = 1:12) +
#   ggtitle("Climatogram for Oslo (1961-1990)")  
# 

