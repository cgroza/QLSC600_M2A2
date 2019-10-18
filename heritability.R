
library(tidyverse)
library(ggplot2)
library(car)

betas <- read_tsv("plink2.PHENO1.glm.logistic", col_names = T)
freqs <- read_tsv("plink2.afreq", col_names = T) %>% filter(ID %in% betas$ID)

freqs <- freqs %>% mutate(P = betas$P, beta.sq = betas$OR^2, HERIT = 2* ALT_FREQS * (1 - ALT_FREQS) * beta.sq)

