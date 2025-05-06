library(ggplot2)
library(tidyverse)
library(cowplot)

bpp <- read.csv("~/mutInference_analysis/simulations/recombination/summary")
true <- read.csv("~/mutInference_analysis/simulations/recombination/trueHist")

bpp_timeG <- rep(-1, dim(bpp)[1])
bpp_time <- rep(-1, dim(bpp)[1])
bpp_pop <- rep("", dim(bpp)[1])
for (i in 1:dim(bpp)[1]) {
  mapping <- intersect(intersect(which(true[,1] == bpp[i,1]), which(true[,2] == bpp[i,2])), which(true[,3] == bpp[i,3]))
  #if (length(mapping) != 0 ){
    bpp_timeG[i] <- true$timeG[mapping] 
    bpp_time[i] <- true$timeMu[mapping]
    bpp_pop[i] <- true$pop[mapping] 
  #  }
}

tmp <-   cbind(true$timeG * (2.0 * 10 ^ -8) , true$timeMu)
bpp$time <- bpp_time
bpp$timeG <- bpp_timeG
bpp$pop <- bpp_pop
# 
for (i in 1:dim(bpp)[1]) {
  if (bpp$pop[i] == "0") {
    bpp$pop[i] = "ABC"
  } else if (bpp$pop[i] == "1") {
    bpp$pop[i] = "AB"
  } else if (bpp$pop[i] == "2") {
    bpp$pop[i] = "A"
  }else if (bpp$pop[i] == "3") {
    bpp$pop[i] = "B"
  }else if (bpp$pop[i] == "4") {
    bpp$pop[i] = "C"
  } else if (bpp$pop[i] == "5") {
    bpp$pop[i] = "C"
  } else if (bpp$pop[i] == "root") {
    bpp$pop[i] = "ABC"
  }
}

relate <- read.csv("~/mutInference_analysis/simulations/recombination/relate/relate_results.txt")
mutance <- read.csv("~/mutInference_analysis/simulations/locusLength/summary")
mut5000 <- mutance[which(mutance$length ==5000), ]

tsdate <- read.csv("~/mutInference_analysis/simulations/recombination/tsdate_results.txt")
aw <- read.csv("~/mutInference_analysis/simulations/recombination/arg_results.txt")

bias <- c(mean((relate$lower + relate$upper)/2 - relate$generations), 
          mean(tsdate$mean - tsdate$generations), 
          mean(aw$mean - aw$generations),
          mean((bpp$mean_time  - bpp$time)/(2.0 * 10^-8)),
          mean((mutance$mean_time  - mutance$time)/(2.0 * 10^-8))
)
RMSE <- c(sqrt(mean(((relate$lower + relate$upper)/2 - relate$generations)^2)),
         sqrt(mean((tsdate$mean - tsdate$generations)^2)),
         sqrt(mean((aw$mean - aw$generations)^2)),
         sqrt(mean(((bpp$mean_time - bpp$time)/(2.0 * 10^-8))^2)),
         sqrt(mean(((mut5000$mean_time - mut5000$time)/(2.0 * 10^-8))^2))
)

coverage <- c(mean((relate$lower < relate$generations) * (relate$generations < relate$upper)),
  mean((tsdate$mean - 1.96 * sqrt(tsdate$var) < tsdate$generations) * 
         ( tsdate$generations < tsdate$mean + 1.96 * sqrt(tsdate$var))), 
  mean((aw$lower_HPD < aw$generations) * (aw$upper_HPD > aw$generations)),
  mean((bpp$time_25 < bpp$time) * (bpp$time < bpp$time_975)),
  mean((mut5000$time_25 < mut5000$time) * (mut5000$time < mut5000$time_975))
  
)

CI_size <- c(mean(relate$upper - relate$lower), 
             mean(tsdate$mean + 1.96 * sqrt(tsdate$var) - (tsdate$mean - 1.96 * sqrt(tsdate$var))), 
             mean(aw$upper_HPD - aw$lower_HPD), 
             mean(bpp$time_975 - bpp$time_25)/(2.0 * 10^-8), 
             mean(mut5000$time_975 - mut5000$time_25)/(2.0 * 10^-8))

names(bias) <- c("relate", "tsdate", "ARGweaver", "MutAnce", "MutAnce no \nrecombination")
names(RMSE) <- names(bias)
names(coverage) <- names(bias)
names(CI_size) <- names(bias)
# plot(bias)
# plot(abs(bias))
# plot(RMSE)
# plot(coverage)
# plot(CI_size)
df <- as.data.frame(cbind(bias,RMSE, coverage, CI_size))
df$method <- rownames(df)
df$method <- as.factor(df$method)

ylim.prim <- c(-7000, 17000)   # in this example, precipitation
ylim.sec <- c(0, 1)    # in this example, temperature

b <- diff(ylim.prim)/diff(ylim.sec)
a <- ylim.prim[1] - b*ylim.sec[1]
df <- cbind(df, (df$coverage*b + a)) 
colnames(df)[3] <- "coverage_original"
colnames(df)[6] <- "coverage"
colnames(df)[4] <- 'CI size'


my_df2 <- df %>% select(method, bias, RMSE,'CI size',coverage) %>% 
#my_df2 <- df %>% select(method, bias, RMSE,CI size) %>% 
  gather(key = "statistic", value = `generations`, -method)
my_df2$statistic <- factor(my_df2$statistic, levels = c("bias", "RMSE", "CI size", "coverage"))


p1 <- ggplot(my_df2, aes(x=statistic, y = generations)) +
  geom_point(aes(color=method)) +
  xlab("")+
  scale_y_continuous( sec.axis = sec_axis(~ (. - a)/b, name = "coverage         ")) + 
  geom_segment(aes(x=3.5, xend = 4.5, y= .95*b + a, yend = .95 * b + a),  lty= 2)+
  geom_segment(aes(x=.5, xend = 1.5, y= 0, yend = 0),  lty= 3)+
  theme_classic() + theme() 

# p2 <- ggplot(df, aes(x = method, y = coverage)) + 
#   geom_point() + 
#   scale_y_continuous(limits=c(0,1)) +
#   theme_classic() + 
#   xlab("")+
#   geom_hline(aes(yintercept = .95),  lty= 2)+
#   theme(axis.text.x = element_text(angle = 45,  hjust = 1)) 



results <- rbind( #cbind(mut5000$time /(2.0 * 10^-8) , rep("zero", dim(mut5000)[1]), mut5000$mean_time /(2.0 * 10^-8), "MutAnce no recomb", mut5000$time_25/(2.0 * 10^-8), mut5000$time_975/(2.0 * 10^-8)), 
                 cbind(bpp$time /(2.0 * 10^-8) , bpp$recomb, bpp$mean_time /(2.0 * 10^-8), "MutAnce", bpp$time_25/(2.0 * 10^-8), bpp$time_975/(2.0 * 10^-8)), 
                 cbind(relate$generations, relate$recomb, (relate$lower + relate$upper)/2, "relate", relate$lower, relate$upper), 
                 cbind(tsdate$generations, tsdate$recomb, tsdate$mean, "tsdate", tsdate$mean - 1.96 * sqrt(tsdate$var), tsdate$mean + 1.96 * sqrt(tsdate$var)), 
                 cbind(aw$generations, aw$recomb, aw$mean, "ArgWeaver", aw$lower_HPD, aw$upper_HPD))
colnames(results) <- c("true", "recomb", "estimated", "method", "lower", "upper")
results <- as.data.frame(results)
results$true <- as.numeric(results$true)
results$estimated <- as.numeric(results$estimated)
results$method <- as.factor(results$method)
results$lower <- as.numeric(results$lower)
results$upper <- as.numeric(results$upper)

xy.limits <- range( c(results$true,results$estimated) )
 
results$recomb[which(results$recomb == "mid")] <- "medium"
# Anna need to replace mutance with recombination, add argweaver, add recombination rates
allScatter <- ggplot(results, aes(x=true, y= estimated )) + 
  geom_point() + 
  xlab("true time (generations)") +
  ylab("inferred time (generations)") +
  facet_grid(recomb~ method) + 
  geom_abline(intercept = 0, slope = 1) +
  scale_x_continuous(limits=xy.limits) + 
  scale_y_continuous(limits=xy.limits) + 
  coord_fixed( ratio=1) + 
  theme_bw() #+ 
  #geom_errorbar(aes(true, ymin = lower, ymax = upper), col= )
pdf("~/mutationSim/figs/all_methods_scatter.pdf", width=8, height = 4)
ggarrange(allScatter, labels = c("a"))
dev.off()
  
noRecomb <- read.table("~/mutInference_analysis/simulations/locusLength/mut_table.txt")
noRecomb <- cbind("zero", noRecomb)
colnames(noRecomb) <- colnames(bpp)[c(1,2,3,16)]
bpp_df <- as.data.frame(rbind(bpp[c(1,2,3,16)], noRecomb))

bpp_df$recomb[which(bpp_df$recomb == "mid")] <- "medium"
bpp_df$recomb <- factor(bpp_df$recomb, levels = c("zero", "medium", "high"))
p_multMut <- ggplot(bpp_df, aes(x = multMut)) + facet_wrap(~recomb)+
  scale_x_continuous( breaks = c(0, 0.5, 1.0), labels =c(0, 0.5, 1.0), position = "bottom" ) +
  geom_histogram(binwidth = .08, aes(y =stat(width*density) )) +  scale_y_continuous(labels = scales::percent, limits=c(0,1), expand = c(0, 0)) + theme_classic() + #coord_cartesian(ylim= c(0,1))+
  xlab("posterior probability of multiple mutations") +
  ylab("percentage of inferences") 

pdf("~/mutationSim/figs/all_methods_summary.pdf", width=8, height = 2.5)
ggarrange(p1, p_multMut, labels = c("b", "c"), nrow = 1, widths = c(3.2,2.5))
dev.off()


