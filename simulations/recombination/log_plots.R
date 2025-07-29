library(ggplot2)
library(tidyverse)
library(cowplot)
library(paletteer)
bpp <- read.csv("~/mutInference_analysis/simulations/recombination/summary")
true <- read.csv("~/mutInference_analysis/simulations/recombination/trueHist")
# Time in generations
bpp$mean_timeG <- bpp$mean_time / (2.0 * 10^-8)
bpp$time_25G <- bpp$time_25/ (2.0 * 10^-8)
bpp$time_975G <- bpp$time_975 / (2.0 * 10^-8)
bpp$oneMut <- (bpp$multMut <.5)

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

bpp$time <- bpp_time
bpp$timeG <- bpp_timeG

bpp1 <- bpp[which(bpp$multMut <.5),]
bpp2 <- bpp[which(bpp$multMut >=.5),]

# ggplot(bpp1, aes(x=time, y=time_25 + time_975)) + geom_point()

relate <- read.csv("~/mutInference_analysis/simulations/recombination/relate/relate_results.txt")
mutance <- read.csv("~/mutInference_analysis/simulations/locusLength/summary")
# Time in generations
mutance$mean_timeG <- mutance$mean_time / (2.0 * 10^-8)
mutance$time_25G <- mutance$time_25/ (2.0 * 10^-8)
mutance$time_975G <- mutance$time_975 / (2.0 * 10^-8)
mutance$timeG <- mutance$time / (2.0 * 10^-8)

relate$mean_time <- (relate$lower + relate$upper)/2

mut5000 <- mutance[which(mutance$length ==5000), ]

tsdate <- read.csv("~/mutInference_analysis/simulations/recombination/tsdate_results.txt")
aw <- read.csv("~/mutInference_analysis/simulations/recombination/arg_results.txt")

# Removes 1 line
zeroRelate <- which(relate$mean_time == 0)
# Removes 2 line
zeroMut5 <- which(mut5000$timeG == 0)

bias <- c(mean(log10(relate$mean_time[-zeroRelate]) - log10(relate$generations[-zeroRelate])), 
          mean(log10(tsdate$mean                  ) - log10(tsdate$generations             )), 
          mean(log10(aw$mean                      ) - log10(aw$generations                 )),
          mean(log10(bpp$mean_timeG               ) - log10(bpp$timeG                      ), na.rm =TRUE),
          mean(log10(bpp1$mean_timeG              ) - log10(bpp1$timeG                     )),
          mean(log10(bpp2$mean_timeG              ) - log10(bpp2$timeG                     ), na.rm =TRUE),
          mean(log10(mut5000$mean_timeG[-zeroMut5]) - log10(mut5000$timeG[-zeroMut5]       ))
)

RMSE <- c(sqrt(mean((log10(relate$mean_time[-zeroRelate]) - log10(relate$generations[-zeroRelate]))^2)),
         sqrt(mean((log10(tsdate$mean                   ) - log10(tsdate$generations             ))^2)),
         sqrt(mean((log10(aw$mean                       ) - log10(aw$generations                 ))^2)),
         sqrt(mean((log10(bpp$mean_timeG                ) - log10(bpp$timeG                      ))^2,  na.rm =TRUE)),
         sqrt(mean((log10(bpp1$mean_timeG               ) - log10(bpp1$timeG                     ))^2)),
         sqrt(mean((log10(bpp2$mean_timeG               ) - log10(bpp2$timeG                     ))^2,  na.rm =TRUE)),
         sqrt(mean((log10(mut5000$mean_timeG[-zeroMut5] ) - log10(mut5000$timeG[-zeroMut5]       ))^2))
)


names(bias) <- c("relate", "tsdate", "ARGweaver", "MutAnce", "MutAnce | 1","MutAnce | 2", "MutAnce no \nrecombination")
names(RMSE) <- names(bias)

df <- as.data.frame(cbind(bias,RMSE))
df$method <- rownames(df)
df$method <- as.factor(df$method)


my_df2 <- df %>% select(method, bias, RMSE) %>% 
  gather(key = "statistic", value = `generations`, -method)
my_df2$statistic <- factor(my_df2$statistic, levels = c("bias", "RMSE"))

p1 <- ggplot(my_df2, aes(x=statistic, y = generations)) +
  geom_point(aes(color=method)) +
  xlab("")+ ylab("log 10 generations") +
  geom_segment(aes(x=.5, xend = 1.5, y= 0, yend = 0),  lty= 3)+
  theme_classic() + 
 scale_color_paletteer_d("colorblindr::OkabeIto") 
p1

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

results <- results[-which(results$estimated == 0),]
allScatter <- ggplot(results, aes(x=true, y= estimated )) + 
  geom_point(shape = 20) + 
  xlab("true time (log generations)") +
  ylab("inferred time (log generations)") +
  facet_grid(recomb~ method) + 
  geom_abline(intercept = 0, slope = 1) +
  scale_x_continuous(limits=xy.limits) + 
  scale_y_continuous(limits=xy.limits) + 
  coord_fixed( ratio=1) +  scale_x_continuous(trans='log10') +
  scale_y_continuous(trans='log10') +
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) #+ 
pdf("~/mutationSim/figs/all_methods_scatter_log.pdf", width=8, height = 5)
ggarrange(allScatter, labels = c("a"))
dev.off()

allScatterLog <- ggplot(results, aes(x=true, y= estimated )) + 
  geom_point(shape = 20) + 
  xlab("true time (generations)") +
  ylab("inferred time (generations)") +
  facet_grid(recomb~ method) + 
  geom_abline(intercept = 0, slope = 1) +
  scale_x_continuous(limits=xy.limits) + 
  scale_y_continuous(limits=xy.limits) + 
  coord_fixed( ratio=1) + scale_x_continuous(trans='log10') +
  scale_y_continuous(trans='log10') +
  theme_bw() #+ 


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

pdf("~/mutationSim/figs/all_methods_summary_log.pdf", width=8, height = 2.5)
ggarrange(p1,  labels = c("b"), nrow = 1, widths = c(3.2,2.5))
dev.off()

