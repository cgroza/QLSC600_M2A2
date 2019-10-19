library(tidyverse)

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
