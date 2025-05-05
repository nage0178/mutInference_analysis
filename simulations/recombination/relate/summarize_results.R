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

mean((bpp$time_25 < bpp$time) * (bpp$time_975 > bpp$time))
  
relate <- read.csv("~/mutInference_analysis/simulations/recombination/relate/relate_results.txt")
#relateHigh <- relate[which(relate$recomb == "high"), ]
mean((relate$lower < relate$generations) * (relate$generations < relate$upper))
mean((relate$lower + relate$upper)/2 - relate$generations)

mutance <- read.csv("~/mutInference_analysis/simulations/locusLength/summary")
mut5000 <- mutance[which(mutance$length ==5000), ]
mean((mut5000$mean_time  - mut5000$time)/(2.0 * 10^-8))

mean((mut5000$time_25 < mut5000$time) * (mut5000$time < mut5000$time_975))

sqrt(mean(((mut5000$mean_time - mut5000$time)/(2.0 * 10^-8))^2))
sqrt(mean(((relate$lower + relate$upper)/2 - relate$generations)^2))

tsdate <- read.csv("~/mutInference_analysis/simulations/recombination/tsdate_results.txt")
#tsdate <- tsdate[which(tsdate$recomb == "high"), ]
sqrt(mean((tsdate$mean - tsdate$generations)^2, na.rm = TRUE))

dim(tsdate)
mean(tsdate$mean - tsdate$generations) 
mean((tsdate$mean - 2 * sqrt(tsdate$var) < tsdate$generations) * 
       ( tsdate$generations < tsdate$mean + 2 * sqrt(tsdate$var)))

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

names(bias) <- c("relate", "tsdate", "ARGweaver", "mutance", "mutanceNoRecomb")
names(RMSE) <- names(bias)
names(coverage) <- names(bias)
names(CI_size) <- names(bias)
plot(bias)
plot(abs(bias))
plot(RMSE)
plot(coverage)
plot(CI_size)
df <- as.data.frame(cbind(bias,RMSE, coverage, CI_size))
df$method <- rownames(df)
df$method <- as.factor(df$method)
library(ggplot2)
library(tidyverse)
ylim.prim <- c(-7000, 17000)   # in this example, precipitation
ylim.sec <- c(0, 1)    # in this example, temperature

b <- diff(ylim.prim)/diff(ylim.sec)
a <- ylim.prim[1] - b*ylim.sec[1]
df <- cbind(df, (df$coverage*b + a)) 
colnames(df)[6] <- "rescale_cov"

my_df2 <- df %>% select(method, bias, RMSE,rescale_cov) %>% 
  gather(key = "statistic", value = `generations`, -method)

ggplot(my_df2, aes(x=method, y = generations)) +
  geom_point(aes(color=statistic)) +
  scale_y_continuous( sec.axis = sec_axis(~ (. - a)/b, name = "coverage         ")) + theme_classic() #+ 



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

library(ggplot2)
xy.limits <- range( c(results$lower,results$upper) )
xy.limits <- range( c(results$true,results$estimated) )

# Anna need to replace mutance with recombination, add argweaver, add recombination rates
ggplot(results, aes(x=true, y= estimated )) + 
  geom_point() + 
  facet_grid(recomb~ method) + 
  geom_abline(intercept = 0, slope = 1) +
  scale_x_continuous(limits=xy.limits) + 
  scale_y_continuous(limits=xy.limits) + 
  coord_fixed( ratio=1) + 
  theme_bw() #+ 
  #geom_errorbar(aes(true, ymin = lower, ymax = upper), col= )
  
ggplot(results, aes(x=method, y = upper - lower)) + geom_point() + facet_grid
