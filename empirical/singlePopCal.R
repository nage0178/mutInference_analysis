chs <- matrix(c(223, 1, 
                178, 46,
                133, 912, 
                222, 2, 
                147, 77,
                147, 77, 
                4, 200), byrow = TRUE, ncol=2)
anc <- c("C", "G", "C", "C", "G", "G", "G")
mut <- c("A", "A", "T", "G", "A", "A", "A")
ref <- c("C", "A", "C", "C", "G", "A", "A")

freq_anc_chs <- rep(0,7)
for (i in 1:7 ){
  if (mut[i] == ref[i])
    freq_anc_chs[i] <- chs[i,1] / (chs[i,1] + chs[i,2])
  else
    freq_anc_chs[i] <- chs[i,2] / (chs[i,1] + chs[i,2])
}

N <- 10000
g <- 20
chs_age <- -2 *freq_anc_chs / (1- freq_anc_chs) * log (freq_anc_chs) * 2 * N * g

gbr <- matrix(c(117,65,
                166,16, 
                38,144,
                4, 178,
                161, 21, 
                157, 25,
                182, 0), byrow= TRUE, ncol = 2)

freq_anc_gbr <- rep(0,7)
for (i in 1:7 ){
  if (mut[i] == ref[i])
    freq_anc_gbr[i] <- gbr[i,1] / (gbr[i,1] + gbr[i,2])
  else
    freq_anc_gbr[i] <- gbr[i,2] / (gbr[i,1] + gbr[i,2])
}

N <- 10000
g <- 20
gbr_age <- -2 *freq_anc_gbr / (1- freq_anc_gbr) * log (freq_anc_gbr) * 2 * N * g

lwk <- matrix(c(198, 0,
                48, 150, 
                181, 17, 
                198, 0, 
                198, 0, 
                112, 86, 
                15, 183), byrow= TRUE, ncol = 2)

freq_anc_lwk <- rep(0,7)
for (i in 1:7 ){
  if (mut[i] == ref[i])
    freq_anc_lwk[i] <- lwk[i,1] / (lwk[i,1] + lwk[i,2])
  else
    freq_anc_lwk[i] <- lwk[i,2] / (lwk[i,1] + lwk[i,2])
}

N <- 10000
g <- 20
lwk_age <- -2 *freq_anc_lwk / (1- freq_anc_lwk) * log (freq_anc_lwk) * 2 * N * g

rbind(chs_age, gbr_age, lwk_age)

# theta = 4 N mu 
N <- .00008 / (4 * .5 * 10 ^ -9)
