library(ggplot2)
library(tidyverse)

eigenv <- read_csv("plink.eigenval", col_names = F) %>% mutate(Rank = row_number())

ggplot(eigenv) + geom_bar(aes(x=Rank, y=log(X1)), stat = "identity") + scale_x_continuous(breaks = 1:20) + ggtitle("PCs by explained variance") + ylab("log(Variance)") + xlab("PC Rank") + theme_bw()

ggsave("scree.pdf")
