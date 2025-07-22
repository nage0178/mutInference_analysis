library(ggplot2)
library(forcats)
library(reshape)
library(ggpubr)
library(cowplot)

times5 <- read.csv("~/mutInference_analysis/empirical/bpp/sat_1/summary", header = TRUE)
times1 <- read.csv("~/mutInference_analysis/empirical/bpp/sat_1_l1000/summary", header = TRUE)
times10 <- read.csv("~/mutInference_analysis/empirical/bpp/sat_1_l10000/summary", header = TRUE)
times5$length <- 5
times1$length <- 1
times10$length <- 10
times <- rbind(times1, times5, times10)
times$length <- as.factor(times$length)
mu_rate <-  10 ^-9

times$gene[which(times$gene == "MCIR_1")] <- 'MC1R\n79'
times$gene[which(times$gene == "MCIR_2")] <- 'MC1R\n78'


#ANNA CHANGE THESE
root_L_HPD <- 0.000434213700  / mu_rate
internal_L_HPD <- 0.000022696500 / mu_rate
root_H_HPD <- 0.000503586000  / mu_rate
internal_H_HPD <- 0.000025122600 / mu_rate


plot_one_time <- ggplot(times) + ylab("time (years)")  + 
  facet_grid( ~gene, space = "free", scales = "free" , switch = 'x') +
  theme(strip.placement = "outside")+
  #facet_wrap(.~gene, scales = 'free_x', nrow = 1,strip.position = 'bottom')+
  geom_rect(ymin = root_L_HPD, ymax = root_H_HPD,
            xmin = -Inf, xmax = Inf, fill = 'grey') +
  geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD,
            xmin = -Inf, xmax = Inf, fill = 'grey') +
 xlab("length (kb)")+
  # scale_x_discrete(labels=c('ASIP', 'MATP', 'MCIR 78', "OCA2", "SLC24A5", "TYR")) +
  geom_point(aes(x=length, y = meanTime /mu_rate)) + geom_errorbar(aes(x=length, ymin = L_HPD / mu_rate, ymax = H_HPD/mu_rate)) +
  theme_classic() +theme(strip.placement = 'outside',strip.background = element_blank(), strip.text.x.bottom = element_text(angle = 90))


# Stacked bar plots

colnames(times)[15] <- "GBR, CHS"
colnames(times)[16] <- "LWK, GBR, CHS"

m_times = melt(times, id.vars=c("gene", "length"),
                measure.vars=c("LWK", "CHS", "GBR", "GBR, CHS", "LWK, GBR, CHS"))
colnames(m_times)[3] <- "population"

pop_one <- ggplot(m_times, aes(x = length , y = value, fill = population)) +
  facet_grid( ~gene, space = "free", scales = "free", switch = 'x') +
  ylab("posterior probability") + 
  xlab("length (kb)")+
  geom_bar(position="stack", stat="identity" ) +# theme( panel.spacing.x = unit(0,"line"),  
                                                  #       panel.spacing.y = unit(0,"line"))
  # facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_classic() +
  scale_y_continuous(expand = c(0,0))+
  theme(strip.background = element_blank(), strip.placement = 'outside', legend.position="top",
        legend.text=element_text(size=10), strip.text.x.bottom = element_text(angle = 90))+ 
  theme(legend.key.size = unit(0.2, 'cm'))

pdf("~/mutationSim/figs/empirical.pdf", height = 4, width = 10)
ggarrange(plot_one_time, pop_one, labels = c("a", "b"))
dev.off()
# End manuscript figures
#####
# Presentation figures 
png("~/mutationSim/figs/empirical_time_blank.png", height = 4, width = 6, units= "in", res = 500)
ggplot(times) + ylab("time (years)")  + 
  facet_grid( ~gene, space = "free", scales = "free" , switch = 'x') +
  theme(strip.placement = "outside")+
  #facet_wrap(.~gene, scales = 'free_x', nrow = 1,strip.position = 'bottom')+
  xlab("length (kb)")+
  #geom_point(aes(x=length, y = meanTime /mu_rate)) + 
  geom_errorbar(aes(x=length, ymin = L_HPD / mu_rate, ymax = H_HPD/mu_rate), col = 'white') +
  geom_rect(ymin = root_L_HPD, ymax = root_H_HPD,
            xmin = -Inf, xmax = Inf, fill = 'grey') +
  geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD,
            xmin = -Inf, xmax = Inf, fill = 'grey') +
  theme_classic() +theme(strip.placement = 'outside',strip.background = element_blank(), strip.text.x.bottom = element_text(angle = 90))
dev.off()

png("~/mutationSim/figs/empirical_time.png", height = 4, width = 6, units= "in", res = 500)
ggplot(times) + ylab("time (years)")  + 
  facet_grid( ~gene, space = "free", scales = "free" , switch = 'x') +
  theme(strip.placement = "outside")+
  #facet_wrap(.~gene, scales = 'free_x', nrow = 1,strip.position = 'bottom')+
  xlab("length (kb)")+
  geom_rect(ymin = root_L_HPD, ymax = root_H_HPD,
            xmin = -Inf, xmax = Inf, fill = 'grey') +
  geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD,
            xmin = -Inf, xmax = Inf, fill = 'grey') +
  geom_point(aes(x=length, y = meanTime /mu_rate)) + 
  geom_errorbar(aes(x=length, ymin = L_HPD / mu_rate, ymax = H_HPD/mu_rate)) +
  theme_classic() +theme(strip.placement = 'outside',strip.background = element_blank(), strip.text.x.bottom = element_text(angle = 90))
dev.off()


png("~/mutationSim/figs/empirical_pop_blank.png", height = 4, width = 6, units= "in", res = 500)
ggplot(m_times, aes(x = length , y = value, fill = population)) +
  facet_grid( ~gene, space = "free", scales = "free", switch = 'x') +
  ylab("posterior probability") + 
  xlab("length (kb)")+
  geom_bar(position="stack", stat="identity" ) +# theme( panel.spacing.x = unit(0,"line"),  
  scale_fill_manual(values=c("white", 
                             "white",
                             "white",
                             "white",
                             "white")) +
  #       panel.spacing.y = unit(0,"line"))
  # facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_classic() +
  scale_y_continuous(expand = c(0,0))+
  theme(strip.background = element_blank(), strip.placement = 'outside', legend.position="top",
        legend.text=element_text(size=10), strip.text.x.bottom = element_text(angle = 90))+ 
  theme(legend.key.size = unit(0.2, 'cm'))
dev.off()

png("~/mutationSim/figs/empirical_pop.png", height = 4, width = 6, units= "in", res = 500)
ggplot(m_times, aes(x = length , y = value, fill = population)) +
  facet_grid( ~gene, space = "free", scales = "free", switch = 'x') +
  ylab("posterior probability") + 
  xlab("length (kb)")+
  geom_bar(position="stack", stat="identity" ) +# theme( panel.spacing.x = unit(0,"line"),  
  #       panel.spacing.y = unit(0,"line"))
  # facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_classic() +
  scale_y_continuous(expand = c(0,0))+
  theme(strip.background = element_blank(), strip.placement = 'outside', legend.position="top",
        legend.text=element_text(size=10), strip.text.x.bottom = element_text(angle = 90))+ 
  theme(legend.key.size = unit(0.2, 'cm'))
dev.off()

######
# pop_one <- ggplot(m_times, aes(x = length , y = value, fill = population)) +
#   facet_wrap(.~gene, scales = 'free_x',nrow = 1,strip.position = 'bottom')+
#   ylab("posterior probability") + 
#   geom_bar(position="stack", stat="identity", ) + 
#  # facet_grid(length~base, space="free_x", scales = "free_x") +
#   theme_bw() + 
#   scale_y_continuous(expand = c(0,0))+
#   theme(legend.position = "none", panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
#   theme(strip.placement = 'outside',strip.background = element_blank())#axis.title.x=element_blank(), axis.text.x=element_blank(), 
#         #axis.ticks.x=element_blank())
# pop_one
m_times <- cbind(m_times, "one")

# ggplot(m_times, aes(x = "one", y = value, fill = population)) + 
#   ylab("Posterior Probability") + 
#   geom_bar(position="stack", stat="identity", ) + 
#   # facet_grid(length~base, space="free_x", scales = "free_x") +
#   theme_bw() + facet_wrap(~gene, nrow = 1)+ 
#   scale_y_continuous(expand = c(0,0))+
#   scale_x_discrete(labels=c('ASIP', 'MATP', 'MCIR 92', 'MCIR 314', "OCA2", "SLC24A5", "TYR")) +
#   theme(legend.position = "none", panel.grid.major = element_blank(), panel.grid.minor = element_blank()) #axis.title.x=element_blank(), axis.text.x=element_blank(), 
# #axis.ticks.x=element_blank())


m_times1 = melt(times[multMut, ], id.vars=c("gene"),
               measure.vars=c("GBR1", "LWK1", "CHS1", "GBRCHS1", "LWKGBRCHS1"))
m_times2 = melt(times[multMut, ], id.vars=c("gene"),
                measure.vars=c("GBR2", "LWK2", "CHS2", "GBRCHS2", "LWKGBRCHS2"))

mult_times <- rbind(m_times1, m_times2)
mutNum <- c(rep("first", dim(m_times1)[1]), rep("second", dim(m_times2)[1]))
mult_times <- cbind(mult_times, mutNum)
mult_times$variable <- substr(mult_times$variable, 1, nchar(as.character(mult_times$variable))-1)

mult_times$mutNum <- as.factor(mult_times$mutNum)

mult_times[which(mult_times$variable == "GBRCHS"), 2] <- "GBR, CHS"
mult_times[which(mult_times$variable == "LWKGBRCHS"), 2] <- "LWK, GBR, CHS"

mult_times$variable <- factor(mult_times$variable, levels = c("LWK", "CHS", "GBR", "GBR, CHS", "LWK, GBR, CHS"))
colnames(mult_times)[2] <- "population"
pop_two <- ggplot(mult_times, aes(x = mutNum , y = value, fill = population)) + facet_wrap(~gene, labeller = labeller(gene = gene.labs))+ xlab("gene") + 
  ylab("Posterior Probability") + 
  geom_bar(position="stack", stat="identity", ) + 
  # facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0))+
  theme(legend.position = "none", panel.grid.major = element_blank(), panel.grid.minor = element_blank()) #+ #axis.title.x=element_blank(), axis.text.x=element_blank(), 


pop_two_leg <- ggplot(mult_times, aes(x = mutNum , y = value, fill = population)) + facet_wrap(~gene, labeller = labeller(gene = gene.labs))+ xlab("gene") + 
  ylab("Posterior Probability") + 
  geom_bar(position="stack", stat="identity", ) + 
  # facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0))+
  theme( panel.grid.major = element_blank(), panel.grid.minor = element_blank()) #+ #axis.title.x=element_blank(), axis.text.x=element_blank(), 
#axis.ticks.x=element_blank())
legend2 <- cowplot::get_legend(pop_two_leg)
leg2 <- as_ggplot(legend2)

pdf("~/mutationSim/figs/empirical_pop_both_1000.pdf", height = 4, width = 12)
ggarrange(pop_one, pop_two, leg2, ncol = 3, labels = c("a", "b", ""), widths = c(5, 5, 1.25)) 
dev.off()

# png("~/mutationSim/figs/empirical_pop_both.png", height = 4, width = 12, res= 1200, units= "in")
# ggarrange(pop_one, pop_two, leg2, ncol = 3, labels = c("a", "b", ""), widths = c(5, 5, 1.25)) 
# dev.off()
# 
# png("~/mutationSim/figs/empirical_pop_one.png", height = 4, width = 6, res= 1200, units= "in")
# pop_one
# dev.off()
# 
# png("~/mutationSim/figs/empirical_pop_two.png", height = 4, width = 6, res= 1200, units= "in")
# pop_two
# dev.off()

pop_two_leg_png <- ggplot(mult_times, aes(x = mutNum , y = value, fill = population)) + facet_wrap(~gene, labeller = labeller(gene = gene.labs))+ xlab("gene") + 
  ylab("Posterior Probability") + 
  geom_bar(position="stack", stat="identity", ) + 
  # facet_grid(length~base, space="free_x", scales = "free_x") +
  theme_bw() + 
  scale_y_continuous(expand = c(0,0))+
  theme(legend.position="bottom")  +
  theme( panel.grid.major = element_blank(), panel.grid.minor = element_blank()) #+ #axis.title.x=element_blank(), axis.text.x=element_blank(), 
#axis.ticks.x=element_blank())

# 
# png("~/mutationSim/figs/empirical_pop_two_leg.png", height = 4, width = 6, res= 1200, units= "in")
# pop_two_leg_png
# dev.off()

###### Extra
#pdf("~/mutationSim/figs/empirical_time_1000.pdf", height = 4, width = 6)
# plot_one <- ggplot(times) + ylab("time (years)")  + 
#   geom_rect(ymin = root_L_HPD, ymax = root_H_HPD, 
#             xmin = -Inf, xmax = Inf, fill = 'grey') +  
#   geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD, 
#             xmin = -Inf, xmax = Inf, fill = 'grey') +  
#   # scale_x_discrete(labels=c('ASIP', 'MATP', 'MCIR 78', "OCA2", "SLC24A5", "TYR")) +
#   geom_point(aes(x=interaction(length,gene,sep = '\n'), y = meanTime /mu_rate)) + geom_errorbar(aes(x=interaction(length,gene,sep = '\n'), ymin = L_HPD / mu_rate, ymax = H_HPD/mu_rate)) + 
#   theme_classic() 
# plot_one
# dev.off()
# 
# png("~/mutationSim/figs/empirical_time_blank.png", height = 4, width = 6, units= "in", res = 500)
# ggplot(times) + ylab("time (years)")  + 
#   scale_x_discrete(labels=c('ASIP', 'MATP', 'MCIR 79', 'MCIR 78', "OCA2", "SLC24A5", "TYR")) +
#  geom_errorbar(aes(gene, ymin = L_HPD / mu_rate, ymax = H_HPD/mu_rate), col= 'white') + 
#   geom_rect(ymin = root_L_HPD, ymax = root_H_HPD, 
#             xmin = -Inf, xmax = Inf, fill = 'grey') +  
#   geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD, 
#             xmin = -Inf, xmax = Inf, fill = 'grey') + 
#   theme_classic() 
# dev.off()
# 
# 
# png("~/mutationSim/figs/empirical_time.png", height = 4, width = 6, units= "in", res = 500)
# #plot_one <- 
# ggplot(times) + ylab("time (years)")  + 
#   geom_rect(ymin = root_L_HPD, ymax = root_H_HPD, 
#             xmin = -Inf, xmax = Inf, fill = 'grey') +  
#   geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD, 
#             xmin = -Inf, xmax = Inf, fill = 'grey') +  
#   scale_x_discrete(labels=c('ASIP', 'MATP', 'MCIR 79', 'MCIR 78', "OCA2", "SLC24A5", "TYR")) +
#   geom_point(aes(x = gene, y = meanTime /mu_rate)) + geom_errorbar(aes(gene, ymin = L_HPD / mu_rate, ymax = H_HPD/mu_rate)) + 
#   theme_classic() 
# dev.off()

#rs...79 is 92

# Similar plots with two mutations
multMut <- which(times$probMult > .01)
firstMut <- cbind(times[ multMut, c(1,6, 7, 8)], rep('first', length(multMut))) 
secondMut <- cbind(times[ multMut, c(1, 9,10,11)], rep("second", length(multMut)))

colnames(firstMut) <- c("gene", "meanTime", "L_HPD", "H_HPD", "mutNum")
colnames(secondMut) <- colnames(firstMut)
summaryMult <- rbind(firstMut, secondMut)

gene.labs <- c("MATP", "MC1R 78", "OCA2")
names (gene.labs) <- (c("MATP", "MC1R_2", "OCA2"))

pdf("~/mutationSim/figs/empirical_time_two_1000.pdf", height = 4, width = 6)
plot_two <- ggplot(summaryMult) + ylab("time (years)") + xlab("gene") + 
  geom_rect(ymin = root_L_HPD, ymax = root_H_HPD, 
            xmin = -Inf, xmax = Inf, fill = 'grey') +  
  geom_rect(ymin = internal_L_HPD, ymax = internal_H_HPD, 
            xmin = -Inf, xmax = Inf, fill = 'grey') +  
  geom_point(aes(x = mutNum, y = meanTime / mu_rate)) + geom_errorbar(aes(mutNum, ymin = L_HPD /mu_rate, ymax = H_HPD / mu_rate)) + 
  theme_classic() + facet_wrap(~gene, labeller = labeller(gene = gene.labs))
plot_two 
dev.off()

# png("~/mutationSim/figs/empirical_time_two.png", height = 4, width = 6,units ="in", res = 1200)
# plot_two 
# dev.off()


pdf("~/mutationSim/figs/empirical_time_both_1000.pdf", height = 4, width = 12)
ggarrange(plot_one, plot_two, ncol = 2, labels = c("a", "b")) 
dev.off()

# png("~/mutationSim/figs/empirical_time_both.png", height = 4, width = 12, units ="in", res = 1200)
# ggarrange(plot_one, plot_two, ncol = 2, labels = c("a", "b")) 
# dev.off()
# Probability of multiple  ??
