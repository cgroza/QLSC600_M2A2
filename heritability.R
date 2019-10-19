library(tidyverse)
library(ggplot2)

betas <- read_table("plink.assoc.logistic", col_names = T)

adj.p <- read_table("plink.assoc.logistic.adjusted", col_names = T)
sig.snps <- filter(adj.p, BONF < 0.05)

freqs <- read_tsv("plink2.afreq", col_names = T) %>% filter(ID %in% betas$SNP)

freqs <- freqs %>% mutate(P = betas$P, beta.sq = betas$BETA^2, HERIT = 2* ALT_FREQS * (1 - ALT_FREQS) * beta.sq, Bonferroni = if_else(ID %in% sig.snps$SNP, "Significant", "Non-significant"))

ggplot(freqs) + geom_jitter(aes(x="SNP", y=log10(HERIT), color = Bonferroni), width = 1) +  theme_bw() + theme(legend.position = "top") + ggtitle("Heritability across SNPs") +
  xlab("") + ylab("log10(SNP heritability)") 

ggsave("snp-heritability.png")
