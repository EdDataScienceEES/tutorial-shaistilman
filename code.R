# Coding Club Tutorial - Model Selection
# Shai Stilman, s2183612@ed.ac.uk
# 18/11/24

library(tidyverse)  # contains ggplot2 (data visualization) and other useful packages
library(cowplot)  # making effective plot grids
library(MASS)  # contains boxcox() function
library(mvtnorm)  #
library(fawraway) #contains the datasets needed for this tutorial

#Writing Models Mathematically ----

##Linear model with continous varibes ----
# Import Data 
load("data/aatemp.rda")  # Load the data
temp_data <- aatemp   #assign name
str(temp_data)
summary(temp_data)

#Understand what type of variable we are working with
str(temp_data$year)
str(temp_data$temp)

#linear model

aatemp_lm <- lm(temp ~ year, temp_data)







##Linear model with categorical variables
# Import Data
butterfat <- data('butterfat')
