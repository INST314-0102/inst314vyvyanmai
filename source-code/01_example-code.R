### Cleaning workspace and loading packages ####
# Before anything else, verify that your environment is totally clear.
# This is important, because old objects can foul up the works
# Clean up the working environment
rm(list = ls())

# At the beginning of a script, it is useful to make sure you have
# downloaded and installed all necessary packages.  I am nearly certain you
# have loaded the tidyverse by now, so I am leaving the line below as a comment.
# You can uncomment it if you need to by removing the #.

# install.packages("tidyverse")

# Load the package.  You will need to include which packages should be loaded at
# the beginning of every script.
library(tidyverse)

# Check for updates
# tidyverse_update()

# You may see a message in the console about packages that are out of date.
# Each of us may have a different set of packages and different versions of
# packages from previous work.  I am using the clever stand-in blah, blah, and
# blah for names of packages that you have installed in the past that are
# currently out of date

# This generally is what the warning message will look like
# The following packages are out of date:
#
# • blah        (2.5.0 -> 2.5.1)
# • blah        (1.3.1 -> 1.3.2)
# • blah       (3.5.2 -> 4.0.0)
# Start a clean R session then run:
# install.packages(c("blah", "blah", "blah"))

# Go ahead, copy the line that starts with install.packages.  Then navigate to
# the top menu Session-->Restart R.  Paste the line that starts with
# "install.packages" into the console and hit enter

# Then you need to load packages again
# library(tidyverse)

### Objects ####
# In this context, an object might be a dataframe OR a single value OR a vector
# OR a function OR quite frankly many things

# We will use the little backwards arrow created by the less than and then the
# minus sign <- to assign names to objects.  There are other options but I do
# not like them.

# There are rules of thumb for naming objects, off the top of my head,
# An object name...
# Rule 1.  cannot be only numerical, e.g., 2
# Rule 2.  cannot have a space in it, use _ or - instead
# Rule 3.  avoid different object named Figure and figure
# Rule 3.  should be meaningful, e.g.,  birthrate-ANOVA-results

# Note, these are similar to conventions for naming files
# see https://speakerdeck.com/jennybc/how-to-name-files

# Create an object called x
x <- 3*4

# View x in the Console
x

# You will also see x in the Environment tab in the upper right pane in RStudio

### Read in a data file that exists in your project repository####

# There are two major reasons that your instructor forces you to use GitHub and
# version control with RStudio.
# Reason #1: this is how real people work together on information science projects
# Reason #2: since your instructor provides all of your datasets *in the
# assignment repository* you can use a simple file path that assumes your
# working directory is set to your project repository

# You can bring data from an outside file into your Environment by "reading" the
# file into R.  *Note* the data file should already be in your /datasets folder
# within the relevant repository.  The only exception is if you are creating the
# dataset by downloading it from wherever or, god forbid, actually entering the
# data within RStudio.

# The important thing for the purposes of your assignments and exams in INST314?

# You must read in the data *using your script.*. In other words,
# either the function read_csv or the function read.csv will appear in your
# .R file that you create, annotate, SAVE, commit with a meaningful commit
# message, and push to GitHub.

# For the purposes of this course,you can use either of two different functions.

#### Read in a data file using read.csv ####

# Simplest case: read in data without specifying anything about the variables.
# The only argument is the file path, in quotes.

titanicData01 <- read.csv("datasets/titanic.csv")

# Read in the data, specifying that all character variables should be treated as
# factors.  Requires an additional argument, stringsAsFactors = TRUE

titanicData02 <- read.csv("datasets/titanic.csv", stringsAsFactors = TRUE)

#### Read in a data file using read.csv ####

# Go to the Files tab in the lower right pane of RStudio.  Find the .csv file
# that you want (in this case it is found in the datasets folder).
# Click on the file name and then select Import Dataset.

# Within the Import Dataset panel you can see how R will treat each variable.
# In the lower right corner of the Import Dataset panel is 3 lines of code.
# You are interested in the middle one, and can cut and paste like I did below.
# I did add the word Data because that is my style.

titanicData03 <- read_csv("datasets/titanic.csv")

# The output in the console from read_csv is interesting.  If you do not specify
# how to treat the variables (as a character, as an integer, as a date), the
# function will just guess.

# For the dataset we named titanicData03, six of the columns are treated as
# character (chr) variables.  One is treated as a numerical (or
# double, dbl) variable.

# But for certain downstream uses, you may want to tell R that a variable is a
# categorical variable, a factor in R lingo.

# read_csv does not have a single argument to treat character variables as
# factors.  Instead it has col_type

# Read in the file again, naming it titanicData04 and specify col_type as
# col_factor. Because I am FAR too lazy to write out the 371 different levels of
# home_destination (frankly, I am too lazy to write out the 3 different levels of
# passenger_class), I include levels=NULL inside col_factor() which generates the
# different levels based on the unique values of the variable.

titanicData04 <- read_csv("datasets/titanic.csv",
                          col_type = list(
                            passenger_class = col_factor(levels = NULL),
                            embarked = col_factor(levels = NULL),
                            home_destination = col_factor(levels = NULL),
                            sex = col_factor(levels = NULL),
                            survive = col_factor(levels = NULL)
                          ))

# If you just want to eyeball the titanic data, you can use the function head()
head(titanicData04)

# The first part of the output is telling you how many observations and how many
# variables are being displayed in the so-called tibble.  A tibble is a
# particular type of dataframe.
# You should see the header row (i.e., first row with variable names),
# followed by the first 6 observations in the dataframe.


### Creating simple vectors ####
# So what if we want to create an object that is a simple numerical vector
# Note: vector refers to a collection of values of the same type, meaning
# you could (and will) have vectors that where each value is a letter or word

# Let's say, for example, you have a homework assignment that is giving you a
# simple dataset and asking for mean, median, etc.

# Start by creating the vector and naming it "age".
# We are going to create a vector that consists of the age of the first 6
# individuals in the titanic dataset.  We will use the function c(), which
# according to handy-dandy Help tab in RStudio found in the lower left pane
# is the function to Combine Values into a Vector or List

age<-c(29, 2, 30, 25, 0.917, 47)

# This could be useful if, for example, you were required to calculate something
# using these values

### Basic calculation examples ####

# Next week we will be performing calculations using a more versatile approach,
# but for now let's say you had *ahem* a quiz that was asking you to find the
# median of a dataset consisting of 5 numbers.  The simplest way, of course, is
# to list the numbers in rank order and choose the middle one.  If you trust
# the computer more than your brain, you can also create a numeric vector and
# then use the median() function

# Since this is for question 3, I'm calling the vector q3data.  Do as you please

q3Data <- c(3,5,8,11,13)
median(q3Data)

# Note that the result is shown in the console.

# You could also use similar simple code to calculate the mean and standard
# deviation.  Both of which you could do by hand, but it's nice to have options.
q4Data <- c(8,19,27,33,43)
mean(q4Data)

# Suppose you are in a crunch, cannot find the right example code, and know you
# JUST NEED TO KNOW WHICH FUNCTION TO USE FOR STANDARD DEVIATION.  You can type
# the words standard deviation into the Help tab search bar and it will return
# related options.  Depending on packages you have installed in the past, your
# results may vary.  But you should absolutely see stats::sd, indicating the
# function sd in the package stats.  stats is a package that comes automatically
# with RStudio, so you can use the function sd without having to install or load

q5Data <- c(1,3,9,2,7)
sd(q5Data)

# If you get an error such as object 'q5Data' not found, you may have either
# forgotten to run the line above OR misspelled.  Both common mistakes.

# Suppose you needed to add up a bunch of numbers to get column totals in a
# table summarizing survey results.  You can do that using R to sum the values,
# and create objects representing each column total.  You can view the actual
# output either in the Environment tab in the upper right corner or by
# calling the object (i.e., running a line of code that is just the name)

totalConservative <- sum(58,125,176,11)
totalConservative
totalModerate <- sum(124,111,126,4)
totalModerate
totalLiberal <- sum(110,20,47,4)
totalLiberal

# And if you wanted the total of responses from all three groups
grandTotal <- sum(totalConservative, totalModerate, totalLiberal)
grandTotal

# The proportion of individuals who identify as liberal is then
propLiberal <- totalLiberal/grandTotal
propLiberal

#README: question 13 and question 14 have different numbers in the tables!


# IF YOU WANTED THE PERCENT, as opposed to the proportion, you would multiply by
# 100
percentLiberal <- 100*(totalLiberal/grandTotal)

# OK, now it is your turn.
# Go back to the assignment document for instructions, and complete your
# homework assignment in a NEW script with the CORRECT name and CORRECT location.



