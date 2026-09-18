# Mai, Vyvyan
rm(list = ls())

#installing package
install.packages("tidyverse")
#lib
library(tidyverse)
#reading dataframe 
df <- read.csv("inst314vyvyanmai-main/datasets/titanic.csv")

x <- 3*4

x

titanicdf2 <- read.csv("inst314vyvyanmai-main/datasets/titanic.csv", stringsAsFactors = TRUE)

titanicdf3 <- read_csv("inst314vyvyanmai-main/datasets/titanic.csv")

titanicdf4 <- read_csv("inst314vyvyanmai-main/datasets/titanic.csv",
                       col_type = list(
                         passenger_class = col_factor(levels = NULL),
                         embarked = col_factor(levels = NULL),
                         home_destination = col_factor(levels = NULL),
                         sex = col_factor(levels = NULL),
                         survive = col_factor(levels = NULL)
                       ))
# Copy and Paste
head(titanicdf4)

age<-c(29, 2, 30, 25, 0.917, 47)

q3Data <- c(3,5,8,11,13)
median(q3Data)

q4Data <- c(8,19,27,33,43)
mean(q4Data)

q5Data <- c(1,3,9,2,7)
sd(q5Data)

totalConservative <- sum(58,125,176,11)
totalConservative
totalModerate <- sum(124,111,126,4)
totalModerate
totalLiberal <- sum(110,20,47,4)
totalLiberal

grandTotal <- sum(totalConservative, totalModerate, totalLiberal)
grandTotal

propLiberal <- totalLiberal/grandTotal
propLiberal

percentLiberal <- 100*(totalLiberal/grandTotal)
percentLiberal

