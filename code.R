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
### example 1 ----
# Import Data 
load("data/aatemp.rda")  # Load the data
temp_data <- aatemp   #assign name
str(temp_data)
summary(temp_data)

#Understand what type of variable we are working with
str(temp_data$year)
str(temp_data$temp)


#adjust 1854 to be year 0
temp_data$year = temp_data$year - min(temp_data$year)

#making model
aatemp_lm <- lm(temp ~ year, temp_data)


#finding alpha and beta
summary(aatemp_lm)

###example 2----
load("data/uswages.rda")  # Load the data
uswages_data <- uswages   #assign name
str(uswages_data)
summary(uswages_data)

#Understand what type of variable we are working with
str(uswages_data$wage)
str(uswages_data$educ)
str(uswages_data$exper)

#making model
uswages_lm <- lm(wage ~ educ + exper, uswages_data)

#finding alpha and beta
summary(uswages_lm)


##Linear model with one factor ----
# Import Data
load("data/butterfat.rda")  # Load the data
butterfat_data <- butterfat   #assign name

str(butterfat_data)
summary(butterfat_data)

#making model
butterfat_lm <- lm(Butterfat ~ Breed, butterfat_data)

#finding alpha and beta
summary(butterfat_lm)

##Linear model with multiple factor ----

# Import Data
#making model
butterfat_more_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)

#finding alpha and beta
summary(butterfat_more_lm)

##Linear model with factor-factor interaction ----

# Import Data
#making model
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)

#finding alpha and beta
summary(butterfat_interact_lm )



#Model Selection ----
##ANOVA ----

# full model:
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)

# sub model:
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)

#ANOVA
#anova(submodel, full model)
anova(butterfat_lm, butterfat_interact_lm)

