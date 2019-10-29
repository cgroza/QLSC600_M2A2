library(tidyverse)
library(MASS)

ld.data <- read_table("plink.ld", col_names = T) %>% select(SNP_A, SNP_B, R2)
## get the other symmetric half of the matrix
ld.data.sym <- tibble(SNP_A=ld.data$SNP_B, SNP_B=ld.data$SNP_A, R2=ld.data$R2)
ld.data <- rbind(ld.data, ld.data.sym)

## load Chisq statistics
gwas.data <- read_table("plink.assoc", col_names = T)
## number of SNPs
M = 271689
## number of individuals
N = 4000

ld.score <- ld.data %>% group_by(SNP_A) %>% summarize(ld.score = sum(R2))
rownames(ld.score) <- ld.score$SNP_A

gwas.data <- gwas.data %>% mutate(ld.score = if_else(SNP %in% ld.score$SNP_A, ld.score[SNP, ]$ld.score , 0)) %>%
  mutate(ld.score = ld.score + 1)


ld.score.regression <- lm(CHISQ ~ ld.score, gwas.data)

ggplot(gwas.data) + geom_point(aes(x=ld.score, y=CHISQ)) +
  geom_smooth(aes(x=ld.score, y=CHISQ), method='lm') +
  geom_text(aes(x=15, y=400), label = paste("h^2=", round(M/N *ld.score.regression$coefficients['ld.score'], 3))) +
  ggtitle("Multiple sclerosis LD score regression") + xlab("LD Score") + ylab("Chi-squared")
ggsave("ldscore.png")

tiled <- gwas.data %>% mutate(quintile = ntile(ld.score, 100)) %>% group_by(quintile) %>%
  summarize(CHISQ_mean = mean(CHISQ), bin.ld.score = mean(ld.score), ld.weight = 1/max(ld.score))
bin.ld.score.regression <- rlm(CHISQ_mean ~ bin.ld.score, data = tiled, weights = ld.weight)
ggplot(tiled) + geom_point(aes(x=bin.ld.score, y=CHISQ_mean)) +
  geom_smooth(aes(x=bin.ld.score, y=CHISQ_mean), method='lm') +
  geom_text(aes(x=10, y=1), label = paste("h^2=", round(M/N *bin.ld.score.regression$coefficients['bin.ld.score'], 3))) +
  ggtitle("Multiple sclerosis LD score regression (binned)") + xlab("LD Score Bin") + ylab("Mean Chi-squared") + theme_bw()
ggsave("binned_ldscore.png")

