

# Tutorial aims:

1. Understand why we do model selection.
2. Understand how to write linear models with categorical variables mathematically.
3. Understand the evaluation metrics used in model selection.
4. Learn about the `step()` function for model selection.
5. Learn about `drop1()` function for model selection.
6. Learn about `ANOVA()` function for model selection.
7. Learn how to these concepts to real problems in ecology and environmental sciences involving data through worked examples.

# Steps:

1. [**Introduction**](#Intro)
  - [Prerequisites](#Prerequisites)
  - [Data and Materials](#DataMat)
2. [**Writing Models Mathematically**](#maths)
  - [Linear Models with Continous Variables](#simple)
  - [Linear Models with Factor (Categorical) Variables](#cat)
3. [**Evaluation Metrics**](#eval)
  - [F-Statistic](#f)
  - [AIC](#AIC)
4. [**Method I: Drop1**](#drop)
  - [`log` transformation](#log)
5. [**MethodII: Step**](#step)
  - [Standardization](#Standardization)
6. [**MethodIII: ANOVA**](#Anova)
  - [Standardization](#Standardization)
7. [**All Together](#together)
  - [Standardization](#Standardization)
7. [**Summary**](#Summary)
8. [**Challenge**](#Challenge)

---
# 1. Introduction
{: #Intro}

Data exists in diverse forms, with varying structures, sizes, and complexities. Consequently, linear models—used to explain and predict data behavior—must be flexible enough to accommodate these variations. In environmental research, for instance, datasets often feature categorical variables that require specialized handling to ensure accurate and meaningful analysis. Additionally, as datasets grow larger and more intricate, it becomes increasingly important to include only the most relevant variables in linear models. This approach prevents overcomplication and mitigates the risk of overfitting, which can undermine the model's reliability and generalizability.

**Effective model selection** plays a critical role in building accurate and efficient models. Achieving this requires a strong understanding of key evaluation metrics, such as AIC (Akaike Information Criterion) and p-values, as well as familiarity with different refinement methods and their interpretations. Mastering model selection empowers researchers to fully leverage complex datasets and develop robust models that strike a balance between simplicity and predictive power.

This tutorial focuses on performing **model selection** for linear models with categorical variables, using three common methods in **R**. We will also explore the mathematical formulation of these models and the evaluation metrics that guide the selection process. By working with a variety of datasets, the tutorial will demonstrate how model selection serves as a powerful tool for tackling real-world data challenges. Finally, the three methods will be integrated into a comprehensive framework, providing a practical approach to model refinement.

---

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

---

## Data and Materials
{: #DataMat}

You can find all the data that you require for completing this tutorial on this [GitHub repository](). We encourage you to download the data to your computer and work through the examples along the tutorial as this reinforces your understanding of the concepts taught in the tutorial. In this tutorial we will work with data from the faraway package, which is a package in R containing different datasets. 

Now we are ready to dive into the world of model selection!

---
# 2. Writing Models Mathematically
{: #maths}

<center> <img src="{{ site.baseurl }}/assets/img/tutorials/data-scaling/stork_photo.JPG" alt="Img" style="width: 800px;"/> </center>

![Cartoon](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/equation_cartoon.png)

Writing linear models mathematically is a useful skill that helps us visualize and understand what our code is doing and what linear models are all about! Before diving into the details, let’s first review the types of variables used in linear models. We focus on **continuous** and **factor (categorical)** variables.

- **Continuous variables** are numerical values that can take any value within a range, e.g., years, population counts, or temperatures.
- **Factor variables** are categorical variables, e.g., country names, species names, or breed types. Factor variables have **levels**, which are the possible categories a variable can take.

For example, if we are analyzing the population of birds in the UK, the categorical variable `country_name` would have 4 levels: Scotland, England, Wales, and Northern Ireland.

Now that we understand the basics, let’s start with how we can write linear models with **continuous variable** mathematically and then move to models that include factor variables.

---

## Linear Models with Continuous Variables
{: #simple}
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
## Linear Models with Factor Variables
{: #cat}

In statistical modeling, **factor variables** represent categorical data with discrete levels. To include these in a linear model, we use **dummy variables**, which encode the different levels of the factor as binary indicators. For example, consider modeling the insulin levels (\(Y_i\)) of rats categorized by size: "fat," "very fat," and "enormous." 

#### Model Representation

A suitable model for insulin levels might be:

$\mu_i = \alpha + \beta_j, \quad \text{if rat } i \text{ belongs to size level } j$,

where:
- $\alpha$ is a baseline mean (overall mean insulin level).
- $\beta_j$ represents the effect of being in size level \(j\).

The values of $j$ correspond to:
- $j = 0$: "fat" rats.
- $j = 1$: "very fat" rats.
- $j = 2$: "enormous" rats.

In other words,

$\mu_i = 
\begin{cases} 
 \alpha + \omega_0 & \text{if rat is fat,} \\ 
 \alpha+ \omega_1 & \text{if rat is very fat,} \\ 
 \alpha + \omega_2 & \text{if rat is enormous.} 
\end{cases}$

So our model fully written out would looks like 

$\mathbf{\mu} = \mathbf{X} * \mathbf{\beta}$, which equals

$\begin{bmatrix}
\mu_1 \\
\mu_2 \\
\mu_3 \\
\mu_4 \\
\mu_5 \\
\mu_6 \\
\mu_7 \\
\mu_8 \\
\mu_9
\end{bmatrix}
=
\begin{bmatrix}
1 & 0 & 0 \\
1 & 0 & 0 \\
1 & 0 & 0 \\
1 & 1 & 0 \\
1 & 1 & 0 \\
1 & 1 & 0 \\
1 & 0 & 1 \\
1 & 0 & 1 \\
1 & 0 & 1
\end{bmatrix}
\begin{bmatrix}
\alpha \\
\beta_1 \\
\beta_2
\end{bmatrix}.
$

This formulation ensures each size group has its own mean insulin level. However, we have to make our model **identifiable** which just means that the one level of the factor is designated as the **basline group**, representing the baseline level against which all other groups are compared. This group corresponds to the case where all dummy variables for the factor are set to 0. Typically, the first level of the factor is chosen as the reference group, but this choice can be adjusted based on context or research objectives.  

To make this work for our rat model we would let $\beta_0 =0$ serving as the basline group. The model can then be written as:

$\mu_i = \alpha + \beta_1 + \beta_2.$

Here:
- $\alpha$: Expected insulin level for "fat" rats (baseline).
- $\beta_1$: Difference in insulin levels between "very fat" rats and "fat" rats.
- $\beta_2$: Difference in insulin levels between "enormous" rats and "fat" rats.

This parameterization highlights that all comparisons are made relative to the reference category ("fat" rats).

---

### Model Example

Assume we observe the following data for $n = 9$ rats:

$
\begin{array}{|c|c|c|c|}
\hline
\text{Rat} & \text{Size} & x_{1i} \, (\text{"very fat"}) & x_{2i} \, (\text{"enormous"}) \\
\hline
1 & \text{Fat} & 0 & 0 \\
2 & \text{Fat} & 0 & 0 \\
3 & \text{Fat} & 0 & 0 \\
4 & \text{Very Fat} & 1 & 0 \\
5 & \text{Very Fat} & 1 & 0 \\
6 & \text{Very Fat} & 1 & 0 \\
7 & \text{Enormous} & 0 & 1 \\
8 & \text{Enormous} & 0 & 1 \\
9 & \text{Enormous} & 0 & 1 \\
\hline
\end{array}
$

The corresponding design matrix ($X$) for the dummy variables is:

$X = 
\begin{bmatrix}
1 & 0 & 0 \\
1 & 0 & 0 \\
1 & 0 & 0 \\
1 & 1 & 0 \\
1 & 1 & 0 \\
1 & 1 & 0 \\
1 & 0 & 1 \\
1 & 0 & 1 \\
1 & 0 & 1
\end{bmatrix},$

where:
- The first column represents the intercept ($\alpha$).
- The second and third columns represent the dummy variables $x_{1,i}$ and $x_{2,i}$, respectively.

### Key Differences Between Dummy and Continuous Variables

Unlike continuous predictor variables, dummy variables represent distinct groups rather than measured values. This distinction has key implications for their usage and interpretation:  

- **Group Inclusion Behavior**: Dummy variables are typically treated as a cohesive set during model selection. Either all the dummy variables associated with a factor are included in the model, or none are. This ensures the factor is analyzed as a whole, reflecting its categorical nature.  
- **Baseline Group**: One category is designated as the basline group, representing the baseline level against which all other groups are compared. This group corresponds to the case where all dummy variables for the factor are set to 0. Typically, the first level of the factor is chosen as the reference group, but this choice can be adjusted based on context or research objectives.  
- **Interpretation of Coefficients**: The coefficients of dummy variables quantify the difference in the response variable between each group and the reference group. For example, a coefficient of 3 for a dummy variable implies that the corresponding group has a response value 3 units higher than the reference group, holding all else constant.  

By representing categorical factors as dummy variables, this framework allows models to incorporate group-based differences effectively, while ensuring clarity in how results are interpreted relative to a baseline.

Lets have a look at an example!

In this next section we will look at the `butterfat` dataset which contains the average butterfat content (percetanges) of milk for random sampes of twenty cows (ten 2 year old cows and ten mature cows (greater than four years old)) from each of the five breeds. 
Now we can look at the basic structure of the dataframe to get some idea of the different variables it contains.

```r
# Import Data
load("data/butterfat.rda")  # Load the data
butterfat_data <- butterfat   #assign name

str(butterfat_data)
summary(butterfat_data)

```

We have Breed as a factor with 5 levels, Ayreshire, Canadian, Guernesy, jersy and Holstein-Fresian. Age is a facor with 2 levls `2 year` and `Mature`.

We can see that the dataset contains information about 100 observation. Lets start by constructing a linear model inevestigtong how butterfat content changes across doffernet breeds.

```r
#making model
butterfat_lm <- lm(Butterfat ~ Breed, butterfat_data)
```

So how would we write this mathematically?  Before we start this lets have a quick look at the summary
```r
#finding alpha and beta
summary(butterfat_lm)
```
This code gives us the following summary 

![Sum Output](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/butterfat_lm_summary.png)

We had 5 levels but we only have the intercept and 4 levels, our Ayreshire breed is missing!

Well since Ayreshire was the first level of the factor it has infact been taken into the intercept so all the other numbers are the difference between butterfat in Ayreshire cows and the other breeeds. For example Candaian cows have roughly $ 0.38$ more butterfat content then Ayreshire cows. So how would we write this mathematically?




---

### Extensions to Multiple Factors

If additional factors, such as **sex**, were included (e.g., male/female), the model expands to:

$\mu_i = \alpha + \beta_j + \gamma_k,$

where:
- $\gamma_k$ is the effect of sex ($k = 0$ for male, $k = 1$ for female).











Further, **interaction terms** between factors can be added to explore how one factor modifies the effect of another:

\[
\mu_i = \alpha + \beta_j + \gamma_k + \delta_{jk},
\]

where $\delta_{jk}$ captures the interaction between size ($j$) and sex ($k$).

This framework allows for flexible modeling of categorical data using factor variables.









Here’s an expanded and more detailed version of your section:

---

### Summary of Interaction Terms and Factor-Continuous Interactions

#### Factor-Factor Interactions

In models with factor interactions, the response variable $\mu_i$ depends on both the additive effects of individual factors and their combined interaction. For instance, in the case of rat size ($j$) and sex ($k$), the model:

\[
\mu_i = \alpha + \omega_j + \gamma_k + \delta_{jk},
\]

includes:
- $\alpha$: The baseline level of the response variable (reference group for size and sex).
- $\omega_j$: The effect of size ($j$), where size might have levels such as "fat," "very fat," and "enormous."
- $\gamma_k$: The effect of sex ($k$), e.g., male or female.
- $\delta_{jk}$: The interaction term, capturing how the effect of size changes depending on sex.

The interaction term $\delta_{jk}$ is critical when the combined influence of two factors is not simply the sum of their separate effects. For example, in a medical dataset, being hypertensive ($j$) or diabetic ($k$) may individually increase cholesterol, but having both conditions might lead to an increase far greater than the sum of their individual effects.

Factor-factor interactions are particularly useful in identifying whether certain combinations of factors lead to synergistic, antagonistic, or entirely unexpected effects on the response variable. In these cases, excluding interaction terms can lead to misinterpretation and biased model predictions.

#### Factor-Continuous Interactions

When a continuous predictor variable (e.g., rat weight, $w_i$) interacts with a factor (e.g., sex, $k$), the model extends to:

$\mu_i = \alpha + \gamma_k + \beta w_i + \delta_k w_i,$

where:
- $\alpha$: The intercept (expected value of $\mu_i$ for the reference sex when $w_i = 0$).
- $\gamma_k$: The main effect of sex ($k$).
- $\beta$: The main linear effect of weight ($w_i$) across all groups.
- $\delta_k$: The interaction coefficient, which adjusts the slope of weight for different levels of sex.

In this model, the slope of the relationship between the continuous predictor ($w_i$) and the response variable ($\mu_i$) varies depending on the factor ($k$). For instance:
- For male rats ($k=0$): $\mu_i = \alpha + \beta w_i$ (single slope $\beta$).
- For female rats ($k=1$): $\mu_i = \alpha + \gamma_1 + (\beta + \delta_1) w_i$ (adjusted slope $\beta + \delta_1$).

This interaction structure allows for different linear trends in the response variable across groups, enabling the model to capture nuanced relationships such as:
- A stronger or weaker effect of weight for one sex compared to the other.
- Opposite trends in weight's impact across groups (e.g., positive in males, negative in females).

#### Higher-Order Interactions

As the number of factors increases, so do the possible interactions:
- **Two-way interactions**: Combinations of two factors (e.g., size and sex, size and diet).
- **Three-way interactions**: Combined effects of three factors (e.g., size, sex, and diet), where the interaction term $\delta_{jkl}$ accounts for how the size-sex relationship depends on diet.

Higher-order interactions can quickly lead to complex models with many parameters. For example, with three factors, the model could include:
$\mu_i = \alpha + \omega_j + \gamma_k + \lambda_l + \delta_{jk} + \delta_{jl} + \delta_{kl} + \delta_{jkl},$
where $\lambda_l$ represents a third factor (e.g., diet) and $\delta_{jkl}$ captures the three-way interaction.

#### Identifiability and Model Constraints

Models with multiple factors and interaction terms often require constraints to ensure identifiability:
- Dummy coding typically sets one level of each factor and interaction to zero as a reference group.
- For factor-continuous interactions, constraints may involve centering continuous predictors (e.g., setting $w_i$ to deviations from the mean) to reduce collinearity between main effects and interaction terms.

Without such constraints, the model matrix can become rank-deficient, meaning the parameters cannot be uniquely estimated.

---

### Practical Implications and Applications

Understanding interaction terms is crucial for:
- **Detecting effect modification**: Identifying cases where the impact of one variable depends on the level of another.
- **Policy or intervention design**: Determining subgroup-specific strategies based on how factors interact.
- **Refining predictions**: Enhancing model accuracy by accounting for complex relationships.

Whether modeling the interaction between factors or between factors and continuous variables, including these terms allows for more realistic and interpretable representations of the underlying data-generating process. However, care must be taken to avoid overfitting, particularly with limited sample sizes. Regularization techniques or hierarchical models may be employed to address this challenge in practice.

---
# 3. Evalution Metrics
{: #eval}

Now that we have mastered the mathematical formulation of our models, let’s shift our focus to the evaluation metrics used for model selection. While we are already familiar with the **p-value**, it’s important to remember that in general, we aim for a p-value less than 0.05. This threshold corresponds to a 95% significance level, which means there is only a 5% chance of observing the given data (or something more extreme) if the null hypothesis is true - If you've forgetten what a null hypothesis ($H_0$) please see [this ANOVA tutorial](https://ourcodingclub.github.io/tutorials/anova/#hypothesis) - A p-value below 0.05 typically indicates that the predictor is statistically significant and contributes meaningfully to the model, beacuse we reject the null hypothsis that our predictor is insignificant.

In this section, explore the **F-statistic** and the **Akaike Information Criterion (AIC)**. These metrics provide additional insights into model performance, helping us evaluate and compare models based on both their fit and complexity.

---

## 3.1 F-Statistic
{: #f}

The **F-statistic** assesses whether a group of predictors in a model, or the overall model itself, significantly improves the fit compared to a simpler baseline model (e.g., one without those predictors). It is calculated as the ratio of explained variance to unexplained variance, standardized by their respective degrees of freedom. 

The **p-value** associated with the F-statistic measures the probability of observing such a result (or one more extreme) if the null hypothesis is true—i.e., if the additional predictors have no real effect. A **p-value less than 0.05** suggests that the predictors or model terms in question significantly contribute to explaining the response variable, at a 95% confidence level.

When interpreting outputs like those from our  `summary()`, or the functions we will look at such as `anova()`, or `drop1()`, in R a significant F-statistic (with a low p-value) indicates that the model terms being tested add meaningful information, and their inclusion of "extra predictors" is justified.

---

## 3.2 AIC
{: #AIC}

The **Akaike Information Criterion (AIC)** is a measure used to compare the goodness of fit between statistical models while penalizing model complexity. It helps in selecting the best model among a set of candidates by balancing fit and simplicity. 

A lower **AIC value** indicates a better trade-off between model accuracy and complexity. When comparing models, the model with the smallest AIC is typically preferred, as it suggests the most efficient explanation of the data with minimal overfitting.

When we look at the output in the next section from our functions like `step()` in R, the AIC guides the selection process by iteratively adding or removing predictors to find the model with the optimal balance of fit and complexity. However, note that AIC values are relative, meaning they should only be compared between models fitted to the same dataset.

---

# 4. Model Selection

Now we have our evaluation metrics we can start having a look at our R functions and understanding their output!

## 4.2. Method I: ANOVA
{: #ANOVA}

Please make sure you have completed [this ANOVA tutorial](https://ourcodingclub.github.io/tutorials/anova/) before you complete this section of the tutorial on one-way ANOVA. In this tutorial we will look at both one-way ANOVA and **two-way ANOVA**.

### 4.2.1 Two-Way ANOVA

Two-way ANOVA is a statistical method used for model selection to test a **full model** against a **sub model**. A full model contains **all** the terms in the model we want to test and the sub model contains **some** of the terms in our model. This basically tests if not including some variables improves our model.

In the context of this tutorial we will use Two-Way ANOVA when we have a model with an *interaction term* and we want to see if this term is significant to our model. As such we are testing the null hypothesis, $H_0$, model without interaction term (sub-model) is better than model with interaction (full-model) against the alternative hypothesis, $H-1$, full model is better than submodel. If we fail to reject $H_0$, which we do when our p-value is less than 0.05, our full model is better and such we should keep our interaction term in the model. It then follows that if we reject $H_0$, which we do when our p-value is greater than 0.05, our sub model is better and such we should remove our interaction term in the model. 

To do Two-Way Anova in R we use the `anova()` function and we call the following `anova(submodel, full model)`.

So know we know what Two-Way Anova does and how to do it but how do we understand the output of ANOVA? The best way to explain this is to look at an example. Lets think back to our butterfat data and make two models that look at how breed and age affect butterfat content in our cows.

```r
# full model:
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)
summary(butterfat_interact_lm)

# sub model:
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)
summary(butterfat_lm)
```
These models are both looking at how breed and age affect butterfat content but the first model (butterfat_interact_lm) assumes that there is an interaction effect between breed and age. This means it considers the possibility that the effect of age on butterfat content depends on the breed, or that the effect of breed on butterfat content depends on age. In other words, the second model (butterfat_lm) assumes that breed and age affect butterfat content independently, with no interaction between the two factors.

We can write these models mathematically looking each of these models summary's respectively.

We get that:

Full Model: 

Sub Model:


It is clear that the full model has *more terms* hence, the name full model. So when we do apply the `anova()` function to these models we will be testing the following:

$H_0: =0$, i.e sub model is a better fit for our data vs.
$H_1: \neq 0$ i.e full model is a better fit for our data.


So now we know what we are testing, lets apply the `anova()` function!
```r
#ANOVA
anova(butterfat_lm, butterfat_interact_lm)
```
This gives us the following output:

![Output](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/butterfat_ANOVA.png)


So what does this mean?

| **Column**       | **Explanation**                                                                                          |
|-------------------|----------------------------------------------------------------------------------------------------------|
| **Res.Df**        | Residual Degrees of Freedom: The number of observations (100) minus the number of parameters in the model. Model 1 has 94 (6 paramaters), and Model 2 has 90 (10 paramaters, 4 more than model 1 due to adding the interaction term). |
| **RSS**           | Residual Sum of Squares: Measures the total variation in the dependent variable (Butterfat) unexplained by the model. Model 1 has 16.094, and Model 2 has a slightly smaller value of 15.580. |
| **Df**            | Difference in degrees of freedom: The reduction in degrees of freedom between the models, which is 4 (from adding interaction terms). |
| **Sum of Sq**     | The additional variation explained by the interaction term: 0.51387. |
| **F**             | F-statistic: Tests whether the additional variation explained by the interaction term is significant relative to the unexplained variation (RSS). Here, \( F = 0.7421 \). |
| **Pr(>F)**        | p-value: The probability of observing an F-statistic as large or larger if the null hypothesis is true. A large p-value (0.5658) indicates no significant improvement with the interaction term. |

**So how can we interpret this?**

The most important part of the anova table is the `Pr(>F)` collumn, as it tells us the p-value of our hypothesis test and whether we should reject the **null hypothesis** that the interaction term does not significantly improve the model (i.e., `Breed` and `Age` affect `Butterfat` independently).

In this example the p-value (0.5658) is much greater than 0.05, so we fail to reject the null hypothesis. This means that adding the interaction term does not significantly improve the model's ability to explain variations in `Butterfat`. 

In conclusion, the simpler model (Model 1: `Butterfat ~ Breed + Age`) is sufficient, and including the interaction term does not add meaningful predictive power, so we **select** Model 1.

