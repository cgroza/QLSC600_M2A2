library(tidyverse)


n <- 271689
dom <- read_table("plink.model") %>% filter(TEST=="DOM")
rec <- read_table("plink.model") %>% filter(TEST=="REC")
assoc <- read_table("plink.assoc.logistic") %>% filter(TEST=="ADD")
assoc$DOM <- dom$P
assoc$REC <- rec$P
theoretical <- -log10(1:n/(n+1))

my.data <- assoc %>% mutate(ADD_SIG = P < 0.05/n) %>% rename(ADD=P) %>% gather(key=TEST, value=sig, ADD, DOM, REC)

add.snps <- my.data %>% filter(TEST=="ADD", sig < 0.05/n) %>% select(SNP)
dom.snps <- my.data %>% filter(TEST=="DOM", sig < 0.05/n) %>% select(SNP)
rec.snps <- my.data %>% filter(TEST=="REC", sig < 0.05/n) %>% select(SNP)

all.intersect <- intersect(intersect(dom.snps$SNP, add.snps$SNP), rec.snps$SNP)
ggplot(my.data %>% mutate(Intersect = SNP %in% all.intersect)) +
  geom_point(aes(x=TEST, y = -log10(sig), color = Intersect)) + geom_hline(yintercept = -log10(0.05/n)) + theme_bw() + ggtitle("P-values under inheritance models")
ggsave("dominance.png")


