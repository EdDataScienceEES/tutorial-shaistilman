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


#making model
butterfat_more_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)

#finding alpha and beta
summary(butterfat_more_lm)

##Linear model with factor-factor interaction ----


#making model
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)

#finding alpha and beta
summary(butterfat_interact_lm )



#Model Selection ----
##ANOVA ----

## One-Way ANOVA 

#no interaction:
#model we are intersted in:
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)

#ANOVA
anova(butterfat_lm)

#interaction:
#model we are intersted in:
butterfat_lm_interact <- lm(Butterfat ~ Breed*Age, butterfat_data)

#ANOVA
anova(butterfat_lm_interact)


## Two-Way ANOVA
# full model:
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)

# sub model:
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)

#ANOVA
#anova(submodel, full model)
anova(butterfat_lm, butterfat_interact_lm)


# Step-Wise Selection

##Drop1

#no interaction model
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)
#apply drop1
drop1(butterfat_lm)


#interaction
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)
#apply drop1
drop1(butterfat_interact_lm)

##Step

# Import Data
load("data/africa.rda")  # Load the data
africa_data <- africa   #assign name
#no interaction
#define linear model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size
+ numelec + numregim, africa_data)

#apply step()
step(africa_lm)

#interaction 
#define linear model
africa_interact_lm <- lm(miltcoup ~ oligarchy*parties + as.factor(pollib) + popn + size
                + numelec + numregim, africa_data)

#apply step()
step(africa_interact_lm)


#All Together ----
# Load required packages
library(palmerpenguins)
library(dplyr)

# Load and clean the penguins dataset
data("penguins")
penguins_clean <- penguins %>%
  filter(complete.cases(.))  # Remove rows with missing values

# Save the cleaned data to a CSV file in the data folder
write.csv(penguins_clean, "data/penguins_clean.csv", row.names = FALSE)


full_model <- lm(body_mass_g ~ species*flipper_length_mm + island*sex, data = penguins_clean)

summary(full_model)

# Method 1: Use drop1 to analyse the impact of removing each variable from the final model
# Drop each term from the model and compare AIC
drop1(full_model) 
#because we have an interaction term, drop1 only looks at those terms and as such doesn't give us infromation on anything apart
#from the interaction term

# Method 2: We can use step to gain an understanding of which unnecessary variables should be dropped 
#- not just looking at the interaction terms
#step 1
step(full_model)
step_model <- lm(formula = body_mass_g ~ species + flipper_length_mm + island + 
                   sex + island:sex, data = penguins_clean)
summary(step_model)

# step 2: We could then use 1-Way ANOVA on our redcued model
anova(step_model)

# Method 4: Or we can Use 2-Way ANOVA to compare the original full model with a reduced model that has no interaction
reduced_model <- lm(body_mass_g ~  species + flipper_length_mm + island + 
                      sex, data = penguins_clean)
anova(full_model, reduced_model)




