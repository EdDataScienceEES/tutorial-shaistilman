#Simple Example using Warpbreaks Data
warpbreaks

#We want to investigate the optimal conditions with min number of breaks in the wool being woven
#We want to invetsiagte gow the type of wool and the tension effects the miin number of breaks
#We have been given the following model and asked to decide if it is sufficent for the data
w_0 <- lm(breaks ~ wool*tension, warpbreaks)

#before we begin model sleection we must look at the model assumptions:

par(mfrow = c(2,2))
plot(w_0)

#then we look at the summary
summary(w_0)

#from this summary output we see that alpga contains woolA temsion L and the interaction of the two and tehrefore the model can be writtena s:

#we see we have a low R^2 which suggests that this model doesn't explain the data well

#we begin model selection by investigating whether the interaction term is significant using Two Way anova

#we build oout submodel


w_1 <- lm(breaks ~ wool + tension, warpbreaks)
anova(w_1, w_0)

#this tells us to use our orginal full model!

#we will look at the alfalfa data from faraway
load("data/alfalfa.rda")  # Load the data
alfalfa_data <- alfalfa #assign name

##investiagte data
str(alfalfa_data)

#we have 3 factor and 1 continous variable

#we have been told to investigate whether the following model is sufficient for the data, and if not 
#find a suitable model using COMBINATION SELECTION
alf_lm <- lm(yield ~ irrigation + inoculum + shade, alfalfa_data)

#start by checking model assumptions
par(mfrow = c(2,2))
plot(alf_lm)
#look at the summary
summary(alf_lm)

#as have lots of variables lets use step() to invetsiagte which variabels we should keep
step(alf_lm)

#step tells us all our variables are significant!

#what about adding interaction terms?
#lets look first at irrigation and shade
alf_lm_new <- lm(yield ~ irrigation*shade + inoculum, alfalfa_data)
#start by checking model assumptions
par(mfrow = c(2,2))
plot(alf_lm_new)
#look at the summary
summary(alf_lm_new)

#as have lots of variables lets use step() to invetsiagte which variabels we should keep
step(alf_lm)