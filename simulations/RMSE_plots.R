library(plotrix)
pdf("~/mutationSim/figs/RMSE_SumStat.pdf", width = 7, height = 2.6)
par(mfrow = c(1, 2))
par(mar = c(4, 5, 1, 1), xaxs='i', yaxs='i')

###
file <- "~/mutInference_analysis/simulations/locusLength/summary"
file1 <- "~/mutInference_analysis/simulations/locusLength/summaryFixed"

sum <- read.csv(file, header =TRUE)
sumFixed <- read.csv(file1, header=TRUE)
sum <- rbind(sum, sumFixed)

sum_1000 <- sum[which(sum$length == 1000),]
sum_5000 <- sum[which(sum$length == 5000),]
sum_10000<- sum[which(sum$length == 10000),]
sum_inf<- sum[which(is.infinite(sum$length)),]

# Root mean square error
RMSE <- matrix(c(1000, 5000, 10000, 15000, 0, 0, 0, 0), byrow = FALSE, nrow = 4)
RMSE[1,2] <- (mean((sum_1000$time - sum_1000$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)/ 1000
RMSE[2,2] <- (mean((sum_5000$time - sum_5000$mean_time)^2))^(1/2)/ (.5 * 10 ^ -9)/ 1000
RMSE[3,2] <- (mean((sum_10000$time - sum_10000$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)/ 1000
RMSE[4,2] <- (mean((sum_inf$time - sum_inf$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)/ 1000

plot(RMSE, xaxt='n', yaxt='n', xlab = "length", ylab = "RMSE", pch = 16, ylim = c(0, 360000/ 1000), xlim = c(0, 16000), yaxs="i", xaxs = "i", type = "b")
Axis(x=c(0,15000), at = c(1000, 5000, 10000, 15000), side=1, labels = c(1000, 5000, 10000, expression(infinity)))
Axis(x=c(0,350000/ 1000), at = c(100000/ 1000, 200000/ 1000, 300000/ 1000), side=2, labels = c(100000/ 1000, 200000/ 1000, 300000/ 1000))
axis.break(1, 12000, style = "slash")
mtext("a", side = 3, line = -.5, adj = -.4, font = 2)

###

file <- "~/mutInference_analysis/simulations/numSamples/summary"
sum <- read.csv(file, header =TRUE)



sum_10 <- sum[which(sum$samples == 10),]
sum_100 <- sum[which(sum$samples == 100),]
sum_200<- sum[which(sum$samples == 200),]

# Root mean square error
RMSE <- matrix(c(10, 100, 200, 0, 0, 0), byrow = FALSE, nrow = 3)
RMSE[1,2] <- (mean((sum_10$time - sum_10$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)/ 1000
RMSE[2,2] <- (mean((sum_100$time - sum_100$mean_time)^2))^(1/2)/ (.5 * 10 ^ -9)/ 1000
RMSE[3,2] <- (mean((sum_200$time - sum_200$mean_time)^2))^(1/2) / (.5 * 10 ^ -9)/ 1000

plot(RMSE,  ylab = "RMSE", xaxt='n', xlab = "samples", pch = 16, ylim = c(0, 350000 / 1000), xlim = c(0, 210), yaxs="i", xaxs = "i", yaxt='n',type = "b")
Axis(x=c(0,350000 / 1000), at = c(100000/ 1000, 200000/ 1000, 300000/ 1000), side=2, labels = c(100000/ 1000, 200000/ 1000, 300000/ 1000))
Axis(x=c(0,210), at = c(10, 100, 200), side=1, labels = c(10, 100, 200))
mtext("b", side = 3, line = -.5, adj = -.4, font = 2)


dev.off()
