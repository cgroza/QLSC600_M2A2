library(tidyverse)
library(ggplot2)
library(car)

p.vals <- read_tsv("plink2.PHENO1.glm.logistic", col_names = T)

n <- nrow(p.vals)
theoretical <- -log10(1:n/(n+1))
ggplot() + geom_point(aes(x = theoretical, y = -log10(sort(p.vals$P, na.last = F)))) + geom_line(aes(x = theoretical, y = theoretical)) +
  ylab("Observed quantiles") + xlab("Theoretical quantiles") + ggtitle("GWAS P-value QQ") + theme_bw()
ggsave("qqplot.png")
