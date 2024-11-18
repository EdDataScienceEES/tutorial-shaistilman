---
layout: tutorial
title: Model Selection 
subtitle: Understanding how to do model selection for linear models with categorical variables.
date: 2024-11-17 12:00:00
author: Shai Stilman
tags: modelling
---


# Tutorial aims:

1. Understand why we do model selection.
2. Understand how to write linear models with categorical variables mathematically.
3. Understand the evaluation metrics used in model selection.
4. Learn about the `step()` function for model selection.
5. Learn about `drop1()` function for model selection.
6. Learn about `ANOVA()` function for model selection.
7. Learn how to these concepts to real problems in ecology and environmental sciences involving data through worked examples.

# Steps:

1. [**Introduction**](#intro)
  - [Prerequisites](#Prerequisites)
  - [Data and Materials](#DataMat)
2. [**Writing Models Mathematically**](#maths)
  - [Linear Models with Continous Variables](#simple)
  - [Linear Models with Factor (Categorical) Variables](#cat)
3. [**Evaluation Metrics**](#eval)
  - [P-value and Hypotheis Test](#pval)
  - [AIC](#AIC)
4. [**Method I: Step**](#step)
  - [`log` transformation](#log)
  - [Square root `sqrt` transformation](#sqrt)
  - [Box-Cox transformation using `boxcox()`](#bc)
  - [Building models using transformed data and reversing transformations](#trans_lin)
5. [**MethodII: Drop1**](#Drop1)
  - [Standardization](#Standardization)
  - [Normalization](#Normalization)
6. [**MethodIII: ANOVA**](#Anova)
  - [Standardization](#Standardization)
  - [Normalization](#Normalization)
7. [**Summary**](#Summary)
8. [**Challenge**](#Challenge)

# 1. Introduction
{: #intro}

Data exists in diverse forms, with varying structures, sizes, and complexities. Consequently, linear models—used to explain and predict data behavior—must be flexible enough to accommodate these variations. In environmental research, for instance, datasets often feature categorical variables that require specialized handling to ensure accurate and meaningful analysis. Additionally, as datasets grow larger and more intricate, it becomes increasingly important to include only the most relevant variables in linear models. This approach prevents overcomplication and mitigates the risk of overfitting, which can undermine the model's reliability and generalizability.

**Effective model selection** plays a critical role in building accurate and efficient models. Achieving this requires a strong understanding of key evaluation metrics, such as AIC (Akaike Information Criterion) and p-values, as well as familiarity with different refinement methods and their interpretations. Mastering model selection empowers researchers to fully leverage complex datasets and develop robust models that strike a balance between simplicity and predictive power.

This tutorial focuses on performing **model selection** for linear models with categorical variables, using three common methods in **R**. We will also explore the mathematical formulation of these models and the evaluation metrics that guide the selection process. By working with a variety of datasets, the tutorial will demonstrate how model selection serves as a powerful tool for tackling real-world data challenges. Finally, the three methods will be integrated into a comprehensive framework, providing a practical approach to model refinement.

## Prerequisites
{: #Prerequisites}

This tutorial is designed for novice and intermediate learners in statistical analysis who enjoy engaging with equations. If equations are not your preference, you might find this tutorial less suited to your needs—consider exploring other resources, such as [this tutorial on ANOVA](https://ourcodingclub.github.io/tutorials/anova/), which serves as a precursor to this guide.  

Depending on your level of expertise, you can tailor your experience by focusing on the sections most relevant to you. Beginners may want to concentrate on understanding evaluation metrics and applying methods like `step` and `drop1`. However, to get the most out of this tutorial, it’s helpful to have a foundational understanding of descriptive statistics and linear models. Familiarity with high school algebra, including functions and equation manipulation, will also aid in grasping the underlying mathematical concepts.

While we will be using the programming language **R** throughout this tutorial, the principles and techniques covered are applicable across various programming environments. To fully engage with the coding examples provided, you should have a basic understanding of:  
- **Linear models** using the `lm()` function  
- Interpreting the **summary output** of linear models  
- Visualizing data with the **`ggplot2` package**  

If you’re new to linar models in R or need a refresher, the Coding Club website offers excellent resources to get you up to speed:  
- [From Distruvutions to Linear Modles](https://ourcodingclub.github.io/tutorials/modelling/)  
- [Introduction to Model Design](https://ourcodingclub.github.io/tutorials/model-design/)




This tutorial builds on these foundational skills, guiding you step-by-step through the process of model selection for linear models with categorical variables.

## Data and Materials
{: #DataMat}

You can find all the data that you require for completing this tutorial on this [GitHub repository](). We encourage you to download the data to your computer and work through the examples along the tutorial as this reinforces your understanding of the concepts taught in the tutorial. In this tutorial we will work with data from the faraway package, which is a package in R containing different datasets. 

Now we are ready to dive into the world of model selection!

# 2. Writing Models Mathematically
{: #maths}

<center> <img src="{{ site.baseurl }}/assets/img/tutorials/data-scaling/stork_photo.JPG" alt="Img" style="width: 800px;"/> </center>

Writing linear models mathematically is a useful skill that helps us visualize and understand what our code is doing and what linear models are all about! Before diving into the details, let’s first review the types of variables used in linear models. We focus on **continuous** and **factor (categorical)** variables.

- **Continuous variables** are numerical values that can take any value within a range, e.g., years, population counts, or temperatures.
- **Factor variables** are categorical variables, e.g., country names, species names, or breed types. Factor variables have **levels**, which are the possible categories a variable can take.

For example, if we are analyzing the population of birds in the UK, the categorical variable `country_name` would have 4 levels: Scotland, England, Wales, and Northern Ireland.

Now that we understand the basics, let’s start with how we can write linear models with **continuous variable** mathematically and then move to models that include factor variables.

## Linear Models with Continuous Variables

Suppose we have $n$ observations, where each observation corresponds to a response variable, $y_i$, treated as a realization of a random variable, $Y_i$. The response variable has an expected value, $\mu_i = \mathbb{E}[Y_i]$, which depends on the associated predictor (explanatory variable), $x_i$.

The simplest case of linear regression assumes:

$\mathbb{E}[Y] = \alpha + \beta x$,

where $\alpha$ is the **intercept**, and $\beta$ is the **slope**. In this context:
- $\alpha$ represents the mean value of $Y$ when $x = 0$.
- $\beta$ indicates the change in $Y$ for a one-unit change in $x$.

For $i = 1, \dots, n$, the general form is:

$Y_i = \alpha + \beta x_i + \epsilon_i$,

where $\epsilon_i$ are independent error terms with:

$\mathbb{E}[\epsilon_i] = 0 \quad \text{and} \quad \text{Var}(\epsilon_i) = \sigma^2.$

Additionally, we assume that the errors $\epsilon_i$ follow a normal distribution:

$\epsilon_i \sim^{\text{i.i.d.}} \mathcal{N}(0, \sigma^2)$,

meaning they are **independent and identically distributed** normal random variables with mean $0$ and variance $\sigma^2$. As a result, the response variable $Y_i$ also follows a normal distribution:

$Y_i \sim^{\text{i.i.d.}} \mathcal{N}(\alpha + \beta x_i, \sigma^2)$.

These assumptions form the foundation of the simple linear regression model.Suppose we have $n$ observations, where each observation corresponds to a response variable, $y_i$, treated as a realization of a random variable, $Y_i$. The response variable has an expected value, $\mu_i = \mathbb{E}[Y_i]$, which depends on the associated predictor (explanatory variable), $x_i$.

The simplest case of linear regression assumes:

$\mathbb{E}[Y] = \alpha + \beta x$,

where $\alpha$ is the **intercept**, and $\beta$ is the **slope**. In this context:
- $\alpha$ represents the mean value of $Y$ when $x = 0$.
- $\beta$ indicates the change in $Y$ for a one-unit change in $x$.

For $i = 1, \dots, n$, the general form is:

$Y_i = \alpha + \beta x_i + \epsilon_i$,

where $\epsilon_i$ are independent error terms.

For this tutorial we do not need to worry $\epsilon_i$ terms but for those who are intersted, in linear regression we assume that $\mathbb{E}[\epsilon_i] = 0 \quad \text{and} \quad \text{Var}(\epsilon_i) = \sigma^2$ and that the errors $\epsilon_i$ follow a normal distribution: $\epsilon_i \sim^{\text{i.i.d.}} \mathcal{N}(0, \sigma^2)$, meaning they are **independent and identically distributed** normal random variables with mean $0$ and variance $\sigma^2$. As a result, the response variable $Y_i$ also follows a normal distribution:

$Y_i \sim^{\text{i.i.d.}} \mathcal{N}(\alpha + \beta x_i, \sigma^2)$.

These assumptions form the foundation of the simple linear regression model and our model assumtptions!.

Now that we have seen how we can write these models mathematically lets look at an example! 

To start off, open a new R script in RStudio and write down a header with the title of the script (e.g. the tutorial name), your name and contact details and the last date you worked on the script.

In this tutorial we will work with data from the faraway package, which is a package in R containing different datasets. Let's load it into our script along with the packages we will use in this part of the tutorial. If you do not have some of these packages installed, use install.packages('package_name') to install them before loading them.

To begin, let’s load the data and inspect it. In this tutorial, we use the `aatemp` dataset, which contains annual mean temperatures for Ann Arbor, Michigan.

```r
# Coding Club Tutorial - Model Selection
# Shai Stilman, s2183612@ed.ac.uk
# 18/11/24

library(tidyverse)  # contains ggplot2 (data visualization) and other useful packages
library(cowplot)  # making effective plot grids
library(MASS)  # contains boxcox() function
library(mvtnorm)  #
library(fawraway) #contains the datasets needed for
```
In this first section we are going to loook at the aatemp dataset which contains information of the anual mean temperatures in Ann Arbor, Michigan. We begin by loading the dataset and having a look at the basic structure of the dataframe to get some idea of the different variables it contains.

```r
# Import Data
aatemp <- data('aatemp.rda')
str(aatemp)
summary(aatemp)
```

From the output of `str(aatemp)`, we see that the dataset has 115 observations with two variables: `year` and `temp`. From their names it is likley they are continous variables, which we can confirm using:

```r
# Check the types of variables
str(temp_data$year)
str(temp_data$temp)
```

The results confirm that `year` is an integer, and `temp` is numeric. Additionally, the first year in the dataset is 1854. To make our linear model more interpretable, we adjust this to treat 1854 as year 0.

```r
# Adjust year to treat 1854 as year 0
temp_data$year <- temp_data$year - min(temp_data$year)
```

Let’s model how the temperature in Ann Arbor has changed over time. In R, we create a simple linear model where `temp` is the response variable, and `year` is the explanatory variable:

```r
# Build the linear model
aatemp_lm <- lm(temp ~ year, data = temp_data)
```

So now we have our model can we write this mathematically?

Well we know that our respone variable $y_i$ is the tempature and our respone variavle $x_i$ is year. So our linear model would be a simple linear model and would look like:

$Y_i = \alpha + \beta x_i + \epsilon_i, \quad i = 1, \dots, n,$ and we would have that $\mathbb{E}[Y] = \alpha + \beta x,$ where $\alpha$ and $\beta$ are unknown parameters to be estimated.

But how do we find $\alpha$ (intercept) and $\beta$ (slope). Well we can look at the summary of our linear model:

```r
# Summarize the model
summary(aatemp_lm)
```
Which gives the following output:

![Summary Output](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/simple_linear_model_summary.png)

From the output:
- $\alpha = 46.693396$, which means that at year 0 (1854), the mean temperature was $46.693396^\circ\mathrm{F}$.
- $\beta = 0.012237$, indicating that the temperature increases by approximately $0.012237^\circ\mathrm{F}$ each year.

So our linear model written mathematically is:

$Y_i = 46.693396 + 0.012237 x_i + \epsilon_i, \quad i = 1, \dots, n,$

Woohoo! We have just written our first linear model mathematically! 

Now, it is very rare we only have one explanatory variable in our linear model, what if we wanted to create a linear model that had multiple explanatory variables, how can we write this mathematically?

If we include multiple continuous explanatory variables, the model extends to:

$Y_i = \alpha + \beta_1 x_{i1} + \beta_2 x_{i2} + \dots + \beta_p x_{ip} + \epsilon_i$

where:
- $x_{i1}, x_{i2}, \dots, x_{ip}$ are the explanatory variables for observation $i$,
- $\beta_1, \beta_2, \dots, \beta_p$ are the corresponding slopes for each predictor,
- $\alpha$ is the intercept,
- $\epsilon_i \sim \mathcal{N}(0, \sigma^2)$ represents the error term.

This framework allows us to account for multiple factors influencing the response variable $Y$.

Lets look at an example!

The `uswages` dataset contains information on 2,000 U.S. male workers sampled from the 1988 Current Population Survey, with real weekly wages adjusted to 1992 dollars. Key variables include `wage` (real weekly wages), `educ` (years of education), and `exper` (years of work experience) and lots more!

Lets begin by loaidng the data into our script and understanding the structure of it.

```r
load("data/uswages.rda")  # Load the data
uswages_data <- uswages   #assign name
str(uswages_data)
summary(uswages_data)
```

Lets say we are intersted in a linear model that predicts wage given years or experience and years of education. Before we start modelling we need to see what type of variables ears or experience and years of education are:

```r
#Understand what type of variable we are working with
str(uswages_data$educ)
str(uswages_data$exper)
```
Now that we know these are continous variables lets get modelling!!

```r
#making model
uswages_lm <- lm(wage ~ educ + exper, uswages_data)
```
So now we have our model can we write this mathematically?

Well we know that our respone variable $y_i$ is the wage and our respone variables are; $x_{i,1}$ as years of education and $x_{i,2}$ as years of experience. So our linear model would look like:

$Y_i = \alpha + \beta_1 x_{i,1} + \beta_2 x_{i,2} + \epsilon_i, \quad i = 1, \dots, n,$ and we would have that $\mathbb{E}[Y] = \alpha + \beta_1 x_{i,1} + \beta_2 x_{i,2}$, where $\beta_1$ corresponds to the coefficienct of years of education and $\beta_2$ the coefficient of years of experience. 

Lets look at the summary of our linear model to find our unknown paramaters: $\alpha$, $\beta_1$ and $\beta_2$

```r
#finding alpha and our beta's
summary(uswages_lm)
```
Which gives us the following output:
![Summary Output](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/multiple_cnts_summary.png)

From the output:
- $\alpha = -242.7994 $, which means when the canditate has 0 years of experience and 0 years in education, the mean salary was roughly $$-242.80$.
- $\beta_1 =  51.1753$, indicating that the candidates wages increases by approximately $$51.18$ each year they were in education.
- $\beta_2 =   9.7748$, indicating that the candidates wages increases by approximately $$9.78$ for each year of experience theu have.

So our linear model written mathematically is:

$Y_i = -242.7994 +  51.1753 x_{i,1} +   9.7748 x_{i,2} + \epsilon_i, \quad i = 1, \dots, n,$

Now that we have mastered writiing equations mathematically when we have continous variables lets have a look at what we do when we have factor variables !
## Linear Models with Categorical Variables

In this next section we will look at the `butterfat` dataset which contains the average butterfat content (percetanges) of milk for random sampes of twenty cows (ten 2 year old cows and ten mature cows (greater than four years old)) from each of the five breeds. 
Now we can look at the basic structure of the dataframe to get some idea of the different variables it contains.

```r
# Import Data
butterfat <- data('butterfat')
str(butterfat)
summary(butterfat)
```

We have Breed as a factor with 5 levels, Ayreshire, Canadian, Guernesy, jersy and Holstein-Fresian. Age is a facor with 2 levls `2 year` and `Mature`.

We can see that the dataset contains information about 100 observation. In this part we will look at how we can model a linear model inebstigtong how butterfat content changes across doffernet breeds nad differnet ages.

