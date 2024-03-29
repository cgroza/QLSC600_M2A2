library(tidyverse)
library(ggplot2)

betas <- read_table("plink.assoc.logistic", col_names = T)
adj.p <- read_table("plink.assoc.logistic.adjusted", col_names = T)

sig.snps <- filter(adj.p, BONF < 0.05)

haploreg <- read_table("haploreg.txt", col_names = F)

freqs <- read_tsv("plink2.afreq", col_names = T) %>% filter(ID %in% betas$SNP)

K = 0.00052

freqs <- freqs %>% mutate(P = betas$P,
                          beta.sq = betas$BETA^2,
                          UNADJ_HERIT = 2* ALT_FREQS * (1 - ALT_FREQS) * beta.sq,
                          Bonferroni = if_else(ID %in% sig.snps$SNP, "Significant", "Non-significant"),
                          ADJ_FACT = ((K*(1-K))^2)/(dnorm(qnorm(K))^2*0.5*(1-0.5)),
                          HERIT = UNADJ_HERIT * ADJ_FACT)

ggplot(freqs) + geom_jitter(aes(x="SNP", y=log10(HERIT), color = Bonferroni), width = 1) +  theme_bw() + theme(legend.position = "top") + ggtitle("Heritability across SNPs") +
  xlab("") + ylab("log10(SNP heritability)")

ggsave("snp-heritability.png")

freqs %>% filter(Bonferroni=="Significant") %>% summarise(TOTAL=sum(HERIT))

betas$Bonferroni <- if_else(betas$SNP %in% sig.snps$SNP, "Significant", "Non-significant")
betas$HERIT <- freqs$HERIT

pruned <- betas %>% filter(Bonferroni == "Significant") %>% select(CHR, SNP, BP, HERIT) %>% group_by(CHR) %>% summarise(H_max = max(HERIT))

print(sum(pruned$H_max))
