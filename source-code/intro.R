# Mai, Vyvyan
rm(list = ls())

#installing package
install.packages("tidyverse")
#lib
library(tidyverse)
# Question one
fscore <- c(0.025, 0.037, 0.123, 0.218, 0.115, 0.254)
fscore
#Question two
fscore_median <- median(fscore)
fscore_median
#Question three
fscore_IQR <- IQR(fscore)
fscore_IQR

#Question four
# I believe it takes na.rm = FALSE and type = 7