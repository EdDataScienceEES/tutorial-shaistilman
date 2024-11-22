# Coding Club Tutorial - Model Selection
# Shai Stilman, s2183612@ed.ac.uk
# 18/11/24

library(tidyverse)  # contains ggplot2 (data visualization) and other useful packages

#Drop1 ----
# Import Data
load("data/africa.rda")  # Load the data
africa_data <- africa   #assign name
#no interaction
#define linear model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size
                + numelec + numregim, africa_data)

#apply drop1
drop1(africa_lm)

#interaction 
#define linear model
africa_interact_lm <- lm(miltcoup ~ oligarchy*parties + as.factor(pollib) + popn + size
                         + numelec + numregim, africa_data)

#apply step()
drop1(africa_interact_lm)

#Step----

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


#Challenge ----
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







