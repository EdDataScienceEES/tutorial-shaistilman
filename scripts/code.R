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

colnames(penguins_clean)
#research partner model

full_model <- lm(body_mass_g ~ species*flipper_length_mm + island*sex + bill_length_mm + bill_depth_mm, data = penguins_clean)

#start by looking at the summary
summary(full_model)
#R^2 = 0.8794, Adjusted R^2 = 0.8749, RSE = 284.8 

#method 1

drop1(full_model) 
#tell us that dropping  species:flipper_length_mm results in a slightly reduced AIC therfore we should drop it 

#define new model 
new_model <- lm(body_mass_g ~ species + flipper_length_mm + island*sex + bill_length_mm + bill_depth_mm, data = penguins_clean)

drop1(new_model)

#no terms should be dropped!
summary(new_model)
#R^2= 0.8792, Adh R^2 = 0.8755, RSE = 284.1



#method 2
step(full_model)
#drops species:flipper_length_mm

#new model:
step_model <- lm(formula = body_mass_g ~ species + flipper_length_mm + island* sex
                 + bill_length_mm + bill_depth_mm, data = penguins_clean)

#summary:
summary(step_model)
#R^2 =  0.8792, Adj R^2 = 0.8755, RSE = 284.1
