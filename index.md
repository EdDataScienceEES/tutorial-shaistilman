<script type="text/javascript" async
    src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/javascript">
    MathJax.Hub.Config({
        tex2jax: {
            inlineMath: [['$', '$'], ['\\(', '\\)']]  // This ensures inline math is rendered
        }
    });
</script>

# Tutorial aims:

1. Understand why we do model selection.
2. Understand how to write linear models with categorical variables mathematically.
3. Understand the evaluation metrics used in model selection.
4. Learn about `ANOVA()` function for model selection.
5. Learn about `drop1()` function for model selection.
6. Learn about the `step()` function for model selection.
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
4. [**Method I: ANOVA**](#anova)
  - [Recap of One-Way ANOVA](#one)
  - [Two-Way ANOVA](#two)
5. [**MethodII: Drop1**](#drop)
  - [Standardization](#Standardization)
6. [**MethodIII: Step**](#step)
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

This tutorial focuses on performing **model selection** for linear models with categorical variables, using 2 common methods: ANOVA and Stepwise model selection. This tutorial will cover 4 functions in **R** that perfrom these model selection. We will also explore the mathematical formulation of these models and the evaluation metrics that guide the selection process. By working with a variety of datasets, the tutorial will demonstrate how model selection serves as a powerful tool for tackling real-world data challenges. Finally, the three methods will be integrated into a comprehensive framework, providing a practical approach to model refinement.

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

## 3.1 F-Statistic and it's Corresponding p-valye
{: #f}

The **F-statistic** assesses whether a group of predictors in a model, or the overall model itself, significantly improves the fit compared to a simpler baseline model (e.g., one without those predictors). It is calculated as the ratio of explained variance to unexplained variance, standardized by their respective degrees of freedom. 

A **large F-statistic** indicates that the model or predictors significantly explain the variability in the dependent variable, suggesting that the model improves the fit compared to a simpler model. It means the predictors are likely contributing meaningfully to the model. On the other hand, a **small F-statistic** suggests that the model does not explain much of the variability, indicating that the predictors may not be significantly affecting the outcome and the model might not be useful. In essence, a large F-statistic suggests a strong model, while a small one suggests a weak or ineffective model.

The **p-value** associated with the F-statistic, tell us the most in terms of model selection. It measures the probability of observing such a result (or one more extreme) if the null hypothesis is true—i.e., if the additional predictors have no real effect. A **p-value less than 0.05** suggests that the predictors or model terms in question significantly contribute to explaining the response variable, at a 95% confidence level.

When interpreting outputs like those from our  `summary()`, or the functions we will look at such as `anova()`, or `drop1()`, in R a significant F-statistic (with a low p-value) indicates that the model terms being tested add meaningful information, and their inclusion of "extra predictors" is justified.

---
## 3.2 AIC
{: #AIC}

The **Akaike Information Criterion (AIC)** is a measure used to compare the goodness of fit between statistical models while penalizing model complexity. It helps in selecting the best model among a set of candidates by balancing fit and simplicity. 

A lower **AIC value** indicates a better trade-off between model accuracy and complexity. When comparing models, the model with the smallest AIC is typically preferred, as it suggests the most efficient explanation of the data with minimal overfitting.

When we look at the output in the next section from our functions like `step()` in R, the AIC guides the selection process by iteratively adding or removing predictors to find the model with the optimal balance of fit and complexity. However, note that AIC values are relative, meaning they should only be compared between models fitted to the same dataset.

---

## 3.3 Residual Sum of Squares(RSS) & The Sum of Sqaures (Sum of Sq)
  
When we look at the output of our model selection functions we will also see something called the **Residual Sum of Squares (RSS)** and **Sum of Squares**. These are fundamental concepts in evaluating how well a statistical model fits the data. They help quantify the variation in the dependent variable that is explained by the predictors versus the variation that remains unexplained. 
 
## 3.3.1 Residual Sum of Squares (RSS)
The RSS measures the amount of variation in the response (dependent) variable that is not explained by the model. It is calculated as the sum of the squared differences between the observed values ($y_i$) and the predicted values ($ \hat{y}_i$) of the dependent variable:  

$RSS = \sum_{i=1}^n (y_i - \hat{y}_i)^2$ 

A **smaller RSS** indicates that the model’s predictions are closer to the actual data, meaning the model fits the data well. Conversely, a larger RSS suggests a poor fit.

# 3.3.2 Sum of Squares (Sum of Sq)

The Sum of Squares measures the total variation in the dependent variable and serves as the baseline against which the model is evaluated. In the functions we will be looking at in R, the **Sum of Squares** helps tells how much variation each predictor explains. By comparing models (e.g., with and without a given predictor), we assess whether the predictor significantly improves the fit.  It is calculates as follows: 
  
$\text{Sum of Sq} = \sum_{i=1}^n (y_i - \bar{y})^2$, where **$bar{y}$)** is mean of the observed values of the dependent variable.

A **large Sum of Sq** for a predictor suggests that the predictor is important for explaining the response variable and therefore should be kept in the model. Therfore, a small Sum of Sq value suggests that the model is not that important for explaining the response variable and should potentially be removed from the model.

---

Together with metrics like AIC and the F-statistic, these measures guide us in deciding which predictors to include or exclude in the model.

So now that we have all of our evaluation metrics we can start having a look at our R functions and understanding their output!

We will start by looking at ANOVA Model Selection

---

# 4. ANOVA Model Selection

**ANOVA (Analysis of Variance) model selection** is a statistical method used to compare models by assessing whether the inclusion of additional predictors significantly improves the fit of a model. It is based on partitioning the variation in the dependent variable into components explained by the predictors and residual (unexplained) variation. ANOVA selection is used to test whether a simpler model (fewer predictors) is statistically different from a more complex model (additional predictors) by comparing their **Residual Sum of Squares (RSS)** value. The test provides an **F-statistic** and a corresponding **p-value** to determine if the extra predictors meaningfully contribute to explaining the response.  

Throughout ANOVA Model Selection the evalaution metric we are intersted in is the **F-Statistic** and its **corresponding p-value**. Before we get into this section please make sure you have completed [this One-Way ANOVA tutorial](https://ourcodingclub.github.io/tutorials/anova/)  as it assumes you already know how to do One-Way ANOVA.

In this section we will look at both one-way ANOVA and **two-way ANOVA**. Before we get into Two-Way ANOVA lets have a quick recap of how we interpret the output of a One-Way ANOVA table.

### 4.1 Recap of One-Way ANOVA
{: #one}

The best way to do this is to look at an example. Lets think back to our butterfat data and consider the model investigating the affect of breed and age on butterfat content in our cows, with no interaction term.

```r
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)
summary(butterfat_lm)
```
Mathematically our model is:

Remeber that we read the One-Way ANOVA from the **bottom up**! When we apply the `anova()` function the model we get the following output:

![One-Way](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/butterfat_one_ANOVA.png)

We start with the bottom of the table:
In the context of model selection, here's what each section of the ANOVA table tells us, especially regarding degrees of freedom (df) and their interpretation:

**1. Residuals:**
- *Interpretation*:
  - The residuals represent the unexplained variation after accounting for the effects of Breed and Age. 
  - The df for residuals is 94, which represents the remaining degrees of freedom after accounting for the effects of the variables in the model. In total, there were 100 data points (n = 100), and since 6 parameters are estimated in the model (5 for Breed + 1 for Age), the residual degrees of freedom are 100 - 6 = 94.
  - In the context of this tutorial, the residual row does not tell us much in terms of how we should select our model.

**2. Age:**
- Null hypothesis ($H_0): Age does not affect butterfat content, i.e 
- *Interpretation*:
  - F value = 1.5976: A smaller F value suggests the effect of age on butterfat content is relatively weak compared to breed.
  - p-value = 0.2094: Since this p-value is greater than 0.05, we fail to reject the null hypothesis, meaning Age does not significantly affect butterfat content.
  - Sum of Sq = 0.271: A smaller Sum of Sqaures values suggests that Age is not that important for explaining the response variable and supports the idea that it should potentially be removed from the mode,
- *Degrees of Freedom (df)*:
  - There is *1 df**for Age. This is because *Age* is a factor with two levels (e.g., young and old), and the df is the number of levels minus one (2 - 1 = 1).

**3. Breed:**
- *Null hypothesis ($H_0$)*: Breed does not affect butterfat content, i.e
- *Interpretation*:
  - F value = 50.1150: A large F value indicates a large effect of breed on butterfat content relative to the unexplained variation (residuals).
  - p-value < 2e-16: The extremely small p-value means we reject the null hypothesis and conclude that Breed significantly affects butterfat content.
  - Sum of Sq = 34.321: This is quite a large value, indicating that Breed is important in explaining the response variable which supports the idea it should be kept into the model.
- Degrees of Freedom (df): There are 4 degrees of freedom for the **Breed** variable. Since the model has 5 levels of the **Breed** factor, the df is one less than the number of levels (5 - 1 = 4). 

Thus from this output we would conclude that Breed has a significant impact on butterfat content, while Age does not and as such we should consdier a model that does *not* include factor variable Age.

What if we have an interaction term? Nothing!

We treat the ineraction term has a variable and test it as we tested above. For example if we consider the model above with an interaction term, i.e:

```r
#construct model
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)
#look at summary
summary(butterfat_lm)
```
From the summary we can write the model mathematically as:

So if we now applied `anova()`:

```r
#apply ANOVA
anova(butterfat_interact_lm)
```
Which gives us the following output:

![Int_Anova](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/butterfat_one_interact_ANOVA.png)

Starting from teh bottom up we can interpret the table as follows:

**1. Residuals**:
   - The residuals represent unexplained variation in the data. With 90 degrees of freedom (100 data points - 6 parameters estimated), they reflect the variance not explained by the model.

**2. Breed:Age Interaction**:
   - *Null hypothesis ($H_0$)*: There is no interaction effect between Breed and Age on butterfat content, i.e,
   - *Interpretation*: The small F-value (0.7421) and the large p-value ($0.5658 > 0.05$) indicate that the interaction between Breed and Age does not significantly improve the model. So we fail to reject the null hypothesis, suggesting that the interaction term is not necessary in the model. Furthermore, the small Sum of Sq value supports this conclusion.
   - *Degrees of Freedom (df)*: There are 4 degrees of freedom for the interaction term, which reflects the product of the levels of the two factors (Breed with 5 levels and Age with 2 levels), minus 1 for each factor (5 - 1 = 4).

**3. Age**:
   - *Null hypothesis ($H_0$)*: Age does not affect butterfat content, i.e,
   - *Interpretation**: The F-value (1.5801) is small, and the p-value (0.2120) is greater than 0.05, so we fail to reject the null hypothesis. This suggests that Age does not significantly affect butterfat content. Furthermore, the small Sum of Sq value supports this conclusion.
   - *Degrees of Freedom (df)*: Age has 1 degree of freedom since it is a single factor with two levels (2 - 1 = 1).

**4. Breed**:
   - *Null hypothesis ($H_0$)*: Breed does not affect butterfat content, i.e
   - *Interpretation*: The large F-value (49.5651) and the extremely small p-value (<2e-16) suggest that Breed significantly affects butterfat content, therefore we reject the null hypothesis. Furthermore, the large Sum of Sq value supports this conclusion.
   - *Degrees of Freedom (df)*: There are 4 degrees of freedom for Breed because it has 5 levels (5 - 1 = 4).

Based on this ANOVA table, we would conclude that Breed significantly affects butterfat content, while Age and the Breed:Age interaction do not. Therefore, a model excluding Age and the interaction term would be more appropriate fit for our data.

Now that we have recaped One-Way ANOVA, we are ready to look at Two-Way ANOVA tables!

---

### 4.2 Two-Way ANOVA
{: #two}

Two-way ANOVA is a statistical method used for model selection to test a **full model** against a **sub model**. A full model contains **all** the terms in the model we want to test and the sub model contains **some** of the terms in our model. This basically tests if not including some variables improves our model.

In the context of this tutorial we will use Two-Way ANOVA when we have a model with an *interaction term* and we want to see if this term is significant to our model. As such we are testing the null hypothesis, $H_0$, model without interaction term (sub-model) is better than model with interaction (full-model) against the alternative hypothesis, $H-1$, full model is better than submodel. If we fail to reject $H_0$, which we do when our p-value is less than 0.05, our full model is better and such we should keep our interaction term in the model. It then follows that if we reject $H_0$, which we do when our p-value is greater than 0.05, our sub model is better and such we should remove our interaction term in the model. 

To do Two-Way ANOVA in R we use the `anova()` function and we call it in the following way `anova(submodel, full model)`.

So know we know what Two-Way ANOVA does and how to do it but how do we understand the output of Two-Way ANOVA table? The best way to explain this is to look at an example. Lets continue with our butterfat data and make two models that look at how breed and age affect butterfat content in our cows.

```r
# full model:
butterfat_interact_lm <- lm(Butterfat ~ Breed*Age, butterfat_data)

# sub model:
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)
```
These models are both looking at how breed and age affect butterfat content but the first model (butterfat_interact_lm) assumes that there is an interaction effect between breed and age. This means it considers the possibility that the effect of age on butterfat content depends on the breed, or that the effect of breed on butterfat content depends on age. In other words, the second model (butterfat_lm) assumes that breed and age affect butterfat content independently, with no interaction between the two factors.

From the previous section we have seen that can write these models mathematically by looking each of these models summary's respectively.

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

In conclusion, the simpler model (Model 1: `Butterfat ~ Breed + Age`) is sufficient, and including the interaction term does not add meaningful predictive power, so we **select** Model 1. This matches what we did above with One-Way ANOVA.

---

So now we know how we can use both One-Way ANOVA and Two-Way ANOVA for model selction and how we can understand their output for this purpose. But what instead of testing full and sub models we wanted to look at if one group is signifcant or not? 

This is called step-wise selection and it is where the `drop1` and `step` functions come in!

---
# 5 Step-Wise Model Selection
{: #stepwise}

Stepwise model selection is a systematic approach to refine a statistical model by either adding or removing predictors based on a specific evaluation criterion. The goal is to strike a balance between a model that fits the data well and one that is not overly complex, thus the accuracy metric we focus on is AIC!

There are three main approaches to stepwise selection:
1. **Forward Selection:** Starts with no predictors and adds variables one at a time, choosing the one that provides the greatest improvement (e.g., lowest AIC) at each step.
2. **Backward Elimination:** Starts with all potential predictors and removes variables one at a time, eliminating the one that worsens the model the least (or improves it the most).
3. **Combination Selection:** Combines forward and backward methods, allowing variables to be added or removed at each step based on the evaluation metric.

Everything shown in this tutorial can be used on all three types of stepwise selection.

The accuracy metric used in stepwise model selection is **AIC**. AIC is a widely used measure for comparing statistical models, and it is based on two key components:
1. **Goodness of Fit:** How well the model explains the observed data.
2. **Model Complexity:** A penalty for the number of predictors (to avoid overfitting).

**The goal is to minimise the AIC**—a lower AIC indicates a better model. This reflects a model that explains the data well without being overly complex.

To begin with lets have a look at the `drop1` function.

---
## 5.1 Drop 1
{: #drop1}

The `drop1` function in R is used during model selection to evaluate the impact of removing individual variables from a model. It one of the most commonly used function in stepwise model selection and it works by comparing the AIC values of models with and without each variable. We remeber from section 3 a **lower AIC** indicates a better model, as it suggests a better balance between fit and complexity and a **high Sum of Sq** indicates the predictor we are looking at significantly helps explain the response variable.

**What `drop1` Does**  
The `drop1` function evaluates what happens to the AIC if each variable in the model is removed one at a time. For each variable:
   - It calculates the AIC of the model without that variable.
   - It provides a table showing the AIC for all possible one-variable-removal models.

**How to Interpret the Results**  
   - If removing a variable reduces the AIC (i.e., leads to a lower AIC), it suggests that the model improves when that variable is dropped. This may happen if the variable does not contribute significantly to the model or introduces unnecessary complexity.
   - If removing a variable increases the AIC, it indicates that the variable is important for the model, and dropping it would harm the balance between fit and complexity.

Thus, we drop the variable that results in the lowest AIC, this may seem a bit counterintuitive as what we want is the lowest AIC model. However, the AIC value represnets the AIC of the model **without** this variable and if this AIC is lower than the current model’s AIC it means that dropping that variable improves the overall model. Thus, in stepwise regression, this variable is removed because it leads to the greatest improvement in model quality according to the AIC.

Lets have a look at some examples of `drop1` and look at how we can interpret the output it gives us. 

### Example With No Interaction Term

Lets continue with our butterfat data and look at our model that looks at breed and age affecting butterfat content in our cows, with no interaction.

```r
no interaction model
butterfat_lm <- lm(Butterfat ~ Breed + Age, butterfat_data)
```
From above we know that this model can be written mathematically as:


Now lets apply `drop1` function and see what happens!
```r
#apply drop1
drop1(butterfat_lm)
```
We get the following output:

![drop1(blm)](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/drop1(butterfat_lm).png)

This `drop1` output evaluates the impact of removing each predictor (`Breed` and `Age`) one at a time on the residual sum of squares (RSS) and Akaike Information Criterion (AIC). 

So what does each collumn mean?

**1. Df:**  
   Degrees of freedom associated with the predictor. For `Breed`, this is 4 because it has multiple levels (5 levels) and for `Age`, this is 1 (Age has 2 levels). The reason `Breed` had 4 df's instead of 5 and `Age` has 1 df instead of 2 is beacuse we took the first of level of each variable into the intercept of the model!

**2. Sum of Sq:**  
   The sum of squares explained by the predictor. This measures how much variation in the response `Butterfat` is explained by the predictor that would be lost if it were removed:
   - `Breed`: Removing `Breed` would result in losing 34.321 units of explained variation in `Butterfat`.
   - `Age`: Removing `Age` would result in losing 0.274 units of explained variation.

**3. RSS (Residual Sum of Squares):**  
   The RSS is the amount of variation in `Butterfat` that remains unexplained by the model. Lower RSS indicates a better-fitting model:
   - `<none>`: The RSS for the current model (with both `Breed` and `Age`) is **16.094**.
   - `Breed`: If `Breed` is removed, the RSS increases to **50.415**.
   - `Age`: If `Age` is removed, the RSS increases slightly to **16.368**.

**4. AIC:**  
   The AIC evaluates the tradeoff between model fit and complexity. A lower AIC indicates a better model:
   - `<none>`: The AIC of the full model is **-170.672**.
   - `Breed`: Removing `Breed` increases the AIC to **-64.487**, which is much worse. This suggests that `Breed` is an important predictor.
   - `Age`: Removing `Age` results in a slight reduction in AIC to **-170.987**, which is marginally better. This suggests that `Age` contributes very little to the model's performance.

So what does all this mean?

**1. Removing `Breed` is a bad idea.**  
The AIC becomes much worse when `Breed` is removed, indicating that it is a critical predictor for explaining `Butterfat`. The high sum of squares (34.321) associated with `Breed` also supports this.

**2. Removing `Age` is potentially acceptable.**  
The AIC improves slightly when `Age` is removed (from -170.672 to -170.987). This suggests that `Age` has minimal impact on the model and could be considered for removal to simplify the model.

**3. Next Step:**  
Based on this output, the `drop1` function suggests that you might proceed by removing `Age` to potentially improve the model's AIC.

### Example With an Interaction Term

What happens if we have an interacton term? Well the `drop1` function only investiagtes whether our interaction term should be kept. Lets look at our butterfat model that looks at breed and age affecting butterfat content in our cows with an interaction term.

```r
no interaction model
butterfat_lm_interact <- lm(Butterfat ~ Breed*Age, butterfat_data)
```
From above we know that this model can be written mathematically as:


Now lets apply `drop1` function and see what happens!
```r
#apply drop1
drop1(butterfat_lm_interact)
```
We get the following output:

![drop1(blm)](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/drop1(butterfat_lm_interact).png)

The output from the `drop1` function helps us assess whether the interaction term significantly contributes to explaining the variability in `Butterfat`.

So what does each collumn mean?

**1. Df:**  
The degrees of freedom associated with the interaction term.  
- `Breed:Age`: The interaction between `Breed` (5 levels) and `Age` (2 levels) has **4 degrees of freedom**. This is because 

**2. Sum of Sq:**  
This column indicates how much variation in the response variable `Butterfat` is explained by the interaction term.  
- Removing the interaction term (`Breed:Age`) would result in losing **0.514 units of explained variation**. This is a relatively small contribution to the variation in `Butterfat`, suggesting that the interaction term has limited importance.

**3. RSS (Residual Sum of Squares):**  
The RSS measures the variation in `Butterfat` that is not explained by the model.  
- `<none>`: The RSS for the full model (including `Breed`, `Age`, and `Breed:Age`) is **15.580**.  
- `Breed:Age`: If the interaction term is removed, the RSS increases to **16.094**, meaning slightly more variation is left unexplained. The increase is small, reflecting the minimal impact of the interaction term.

**4. AIC (Akaike Information Criterion):**  
The AIC evaluates the tradeoff between model fit and complexity. Lower AIC values indicate better models:  
- `<none>`: The AIC of the full model is **-165.92**.  
- `Breed:Age`: Removing the interaction term decreases the AIC to **-170.67**, which is better. This suggests that the simpler model (without the interaction term) is preferred based on AIC.

So what does this mean?

**1. Removing the interaction term is likely a good idea.**  
The AIC improves significantly (from **-165.92** to **-170.67**) when the interaction term is removed, indicating that the simpler model (without the interaction term) balances fit and complexity better. The small **Sum of Sq** (0.514) further supports that the interaction does not meaningfully contribute to explaining `Butterfat`.

**2. The main effects of `Breed` and `Age` remain critical.**  
While the interaction is not important, this does not affect the significance of the main effects (`Breed` and `Age`), which are likely still contributing to explaining the variation in `Butterfat`.

**3. Next Steps: Simplify the Model**  
Based on this output, the `drop1` function suggests removing the interaction term (`Breed:Age`) to improve the model. This will result in a simpler model:

---

Tada now we know that we can use `drop1` function in R and understand its ouput for both interaction and no interaction models for model selection! 

But what if we have a big model with lots of different variables, like our miltary coups and politics in sub-Saharan Africa data example, using `drop1` over and over would be very tedious and not very efficient. This is where the `step` function comes in!


---
## 5.2 Step

While `drop1` focuses on assessing variable removal, the `step` function automates the stepwise process, iteratively adding or removing variables to optimise the model based on a chosen metric, typically AIC. 

**How the `step` Function Works**

The `step` function in R automates stepwise model selection by evaluating the AIC for all possible additions and/or deletions of predictors at each step. Here's how it works:
1. The function starts with an initial model (either the full model or an empty model).
2. It iteratively evaluates potential models:
   - In **forward selection**, it tries adding each variable and calculates the AIC.
   - In **backward elimination**, it tries removing each variable and calculates the AIC.
   - In **stepwise selection**, it does both and chooses the best action (add/remove).
3. The process stops when no action (adding or removing a variable) improves the AIC.

The final model is the one with the lowest AIC achieved during the process, and is the model that should be used.

### 5.2 Step  
{: #step}  

The `step` function in R automates the process of stepwise model selection, iteratively adding or removing variables to optimize the model based on a chosen metric, typically the **Akaike Information Criterion (AIC)**. This method evaluates the tradeoff between model fit and complexity, aiming to identify the model with the **lowest AIC**.  

**What `step` Does**  
The `step` function systematically examines models by either:  
1. *Backward elimination:** Starting with a full model, it removes variables one by one, calculating the AIC for each reduced model.  
2. *Forward selection:** Starting with an intercept-only model, it adds variables one by one, calculating the AIC for each expanded model. 3. *Comibation selection:** A combination of both approaches, iteratively adding and removing variables to find the optimal model.  


**How to Interpret the Results**  

For each step in the process, the `step` function provides a summary table that includes the follwoing:  
### Summary of How to Interpret the `step()` Function Output in General:

*1. Starting Model**: 
   - The output begins with the initial model, which includes all predictors (in backward elimination) or none (in forward selection). It also shows the AIC of this model, which serves as a baseline for comparison.
   
*2. Stepwise Selection Process**: 
   - The algorithm iterates through multiple steps, evaluating models with different combinations of predictors. It adds or removes variables and computes the AIC at each step, selecting the model with the **lowest AIC**.
   - For iteration the `step` function creates a summary table which shows the details of each model, the models are listed from **lowest to highest** AIC:
       - The **<none> Row** shows the current model’s performance (AIC, RSS, etc.) before any changes (i.e., before any predictor is removed), it serves as a reference point for comparing the impact of removing predictors and helps assess how each variable removal affects the model.       
       - The **Df** (Degrees of Freedom), **Sum of Squares (Sum of Sq)**, **Residual Sum of Squares (RSS)**, and **AIC** columns help track how each predictor impacts the model’s performance:

| **Column**                     | **What It Represents**                                                                                                                                   | **Why It's Important**                                                                                                                                                           | **How Each Column Helps Track Impact**                                                                                                                                               |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Df (Degrees of Freedom)**     | The number of parameters (or pieces of information) associated with each predictor minus 1.                                                                    | Indicates the complexity of the model. A predictor with higher Df typically contributes more parameters to the model. The removal of a predictor reduces the model's Df.           | Shows how the number of parameters changes when a predictor is added or removed.                                                                                                       |
| **Sum of Squares (Sum of Sq)**  | The amount of variation explained by each predictor in the model.                                                                                     | Shows the contribution of each predictor to explaining the variance in the dependent variable. Larger values indicate greater contribution.                                       | Indicates how much variation is explained by a predictor. A larger value means the predictor contributes more to explaining the response variable.                                  |
| **Residual Sum of Squares (RSS)** | The amount of unexplained variance (errors) after fitting the model.                                                                                 | A lower RSS indicates a better-fitting model because the model explains more of the variance in the data. The goal is to minimize RSS.                                           | Reveals how much unexplained variance remains after fitting the model. A lower RSS suggests better model fit.                                                                         |
| **Akaike Information Criterion (AIC)** | A measure used for model selection that balances model fit and complexity (number of parameters).                                                   | A lower AIC indicates a better model that balances fit and complexity. The `step()` function selects models based on the lowest AIC.                                             | The primary measure for model selection. The goal is to minimize AIC by selecting the model with the best balance between complexity and fit.                                        |

   
3. **Final Model**:
   - After the iterations, the final model is displayed, which has the **lowest AIC** and is considered the best model based on the AIC criterion.
   - After the function makes a selection, the coefficients of the final model show the impact of each predictor on the outcome variable.

**Key Points for Interpretation**  
- *Lower AIC is better:** The goal is to minimize the AIC by selecting variables that improve the balance between fit and complexity.
- At each iteration we only remove **one** variable to maintain control over model complexity, accurately assess each predictor’s impact, and prevent overfitting. This iterative approach ensures that the model is gradually simplified while preserving its predictive power. By removing variables one by one, the process allows for careful evaluation of how each predictor affects the model's performance (AIC and fit), avoids drastic changes that could harm the model, and ensures computational efficiency.
- The process stops when *no variable addition or removal reduces the AIC further.  
- *Removed variables:** Variables whose exclusion lowers the AIC were likely not contributing significantly to the model.  
- *Added variables:** Variables whose inclusion lowers the AIC improve the model by explaining additional variability in the response.  


 **Why Use `step`?**  
The `step` function is particularly useful when dealing with a large number of predictors, as it automates the model selection process. It ensures a systematic evaluation of the impact of each variable, saving time and effort compared to manually using `drop1`. However, caution is needed to avoid overfitting or underfitting, as the process is driven solely by AIC without considering domain knowledge or practical significance.  
 
Lets have a look at some examples with and without interaction terms! Lets think back to our `africa` data about the miltary coups and politics in sub-Saharan Africa. In both examples we will do **backward selection**
 
### Example Without an Interaction Term

Lets begin with defining our linear model: 

```r
#define linear model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size
+ numelec + numregim, africa_data)
#check summary
summary(africa_lm)
```
From the summary and section 1 we know that this model can be written mathematically as:

This is a huge model with lots of predictors. How can we be sure that all these predictors are necessary and we are not overfitting? The `step` fucntion!

Lets apply the `step` function and see what happens:

```r
#apply step()
step(africa_lm)
```

We get the following output:

![step(africa_lm_1/3)](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/step_output_africa_1%3A3.png)
![step(africa_lm_2/3)](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/step_output_africa_2.3.png)
![step(africa_lm_3/3)](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/step_output_africa_3%3A3.png)


Try not be put off by how large an output this is as it is pretty straightforward to interpret!
The output of the `step()` function is a result of **stepwise model selection** using AIC. The goal is to iteratively remove predictors from the model (or add them, if necessary) to minimise the AIC, which balances model fit and complexity. Here's a breakdown of each part of the output:

### Step 1: Initial Model:

Before we see our summary table we have the following output:
```r
Start:  AIC=31.0
miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + numelec + numregim
```

 This tell us that our starting model with all the predictors: `oligarchy`, `as.factor(pollib)`, `parties`, `popn`, `size`, `numele`, and `numregim`, has an AIC value of $31.01$.

Our summary output table:
```r
                    Df Sum of Sq    RSS    AIC
- numregim           1    0.5599 57.809 29.418
- size               1    0.9849 58.234 29.726
- numelec            1    1.0103 58.259 29.744
- popn               1    1.7987 59.048 30.308
<none>                           57.249 31.009
- parties            1    4.0115 61.261 31.854
- as.factor(pollib)  2    7.3485 64.598 32.081
- oligarchy          1   24.3257 81.575 43.882
```
tells us what each model with the specified variable does to our models Sum of Sqaures, RSS and AIC. Refer to the table above for a more in depth explanation of each collumn.
Based on the output we can see that:
- Removing `numregim` decreases AIC from **31.01** to **29.42**, which suggests that removing `numregim` improves the model.
- Removing `oligarchy` leads to a much worse AIC of **43.88**, indicating that it’s an important predictor.

### Step 2: New Model After Removing `numregim`

Before we see our summary table we have the following output:
```r
Step:  AIC=29.42
miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + numelec
```
This tells that the updated model after removing `numregim` has an AIC of **29.42**, and what variables it contains.

We get the following summary output.
```r
                    Df Sum of Sq    RSS    AIC
- numelec            1    0.5391 58.348 27.808
- size               1    0.9514 58.760 28.103
<none>                           57.809 29.418
- popn               1    2.9556 60.765 29.512
- as.factor(pollib)  2    7.0078 64.817 30.224
- parties            1    4.2281 62.037 30.383
- oligarchy          1   30.9364 88.745 45.420
```
Again, the `step()` function evaluates the impact of removing each predictor:
- **Removing `numelec`** decreases AIC to **27.81**, suggesting that `numelec` is important.
- **Removing `oligarchy`** significantly worsens the model with an AIC of **45.42**.

This process repeats untill we get to our final model, we know we have our final model when `<none>` is at the top of our summary table output, i.e the model with no change has the lowest AIC value.

In our example this looks like:
```r
Step:  AIC=26.1
miltcoup ~ oligarchy + as.factor(pollib) + parties

                    Df Sum of Sq    RSS    AIC
<none>                           61.614 26.095
- parties            1     4.848 66.463 27.277
- as.factor(pollib)  2     9.415 71.030 28.068
- oligarchy          1    37.888 99.502 44.225
```
This tells us that no variables should be removed and we have reached our final model!

The `step`  function then gives us a `Coefficients` table:
```r
Call:
lm(formula = miltcoup ~ oligarchy + as.factor(pollib) + parties, 
    data = africa_data)

Coefficients:
       (Intercept)           oligarchy  as.factor(pollib)1  as.factor(pollib)2  
           1.53667             0.16884            -0.66190            -1.60340  
           parties  
           0.03002  
```
This `Coefficients` table shows the estimated effect of each predictor on the dependent variable `miltcoup`.

---

What happens if we have an interaction term? Nothing! The `step` function treats the interaction term as a variable in itself

### Example With an Interaction Term

Lets have a look at an example think back to our `africa_interact_lm` model where we assumed there was interaction betweeen the number years country ruled by military oligarchy from independence to 1989 and the number of legal political parties in 1993.

```r
#define linear model with interaction
africa_interact_lm <- lm(miltcoup ~ oligarchy*parties + as.factor(pollib) + popn + size
+ numelec + numregim, africa_data)
```
This is a very complex model with lots of predictors. Lets applt the  `step` fucntion to reduce our model so we can be sure that all these predictors are necessary and we are not overfitting? 

```r
#apply step()
step(africa_interact_lm)
```
This gives us the following output:

![step(africa_interact)_1/2](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/step(africa_interact)_1%3A2.png)
![step(africa_interact)_2/2](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/step(africa_interact)_2%3A2.png)

We we interpret as follows:
#### Step 1: Initial Model

The starting model is:

```r
Start:  AIC=28.42
miltcoup ~ oligarchy * parties + as.factor(pollib) + popn + size + 
    numelec + numregim
```

This model includes the interaction term `oligarchy*parties` and other predictors: `as.factor(pollib)`, `popn`, `size`, `numele`, and `numregim`, with an initial AIC of 28.42.

We get the following output:

```r
                    Df Sum of Sq    RSS    AIC
- size               1    0.5431 51.871 26.866
- numregim           1    0.6285 51.957 26.935
- numelec            1    2.3906 53.719 28.336
<none>                           51.328 28.424
- as.factor(pollib)  2    6.4664 57.795 29.407
- popn               1    4.0301 55.358 29.599
- oligarchy:parties  1    5.9209 57.249 31.009
```
We see that this output has the same format as what we have seen in the previous example, we just have the term `oligarchy:parties` which represents our interaction term.
From this output, we can observe:
- **Removing `size`** decreases the AIC from 28.42 to 26.87, indicating that `size` can be removed without negatively impacting the model's performance.
- **Removing `oligarchy:parties`** leads to a much higher AIC (31.01), suggesting that the interaction term is important for the model.

This repeats untill we get to our final model in exactly the same way as our previous example.

The final model, with the lowest AIC, in this example is:

```r
Call:
lm(formula = miltcoup ~ oligarchy + parties + as.factor(pollib) + 
    popn + oligarchy:parties, data = africa_data)
```

The coefficients for the final model are:

```r
Coefficients:
       (Intercept)           oligarchy             parties  as.factor(pollib)1  
          1.885898            0.065015           -0.002222           -0.729212  
as.factor(pollib)2                popn   oligarchy:parties  
         -1.590386            0.021884            0.005076
```

This table shows the estimated effect of each predictor on the dependent variable `miltcoup`, with the interaction term included in the final model.
 
---

Now that we've covered a range of individual methods for model selection—evaluation metrics like **F-statistics**, **AIC**, **RSS**, and **Sum of Squares**, as well as **ANOVA** and **stepwise selection**—the next logical step is to understand how to combine these techniques to make more robust and informed decisions when selecting the best model for our data.

Why do we use all of these methods together?

Each of these methods provides a unique perspective on the model, and by considering them in combination, we get a fuller understanding of how well the model fits, how much complexity it introduces, and whether it's the most appropriate choice for the data at hand:

1. **Evaluation Metrics** (F-statistics, AIC, RSS, Sum of Squares) give us quantitative measures to compare the performance of different models. AIC, for example, balances model fit and complexity, while RSS focuses on the residuals and how well the model explains the variance in the data. F-statistics and p-values allow us to test the significance of predictors in our models.

2. **ANOVA** helps us compare models with different factors or interaction terms. One-way ANOVA can be useful when testing the impact of one categorical predictor, while two-way ANOVA allows us to evaluate the interaction between two categorical predictors. These methods can reveal important insights into how predictors work together to explain the variability in the response.

3. **Stepwise Selection** (using functions like **step()** and **drop1()**) provides a method for iteratively adding or removing predictors from the model based on criteria such as AIC. It helps refine the model by identifying the most influential predictors, minimizing overfitting and underfitting. Stepwise selection offers a data-driven approach to model simplification.

By combining all of these methods, we aim to strike a balance between model complexity and accuracy. For example, we might use **AIC** for model comparison while considering **ANOVA** to ensure the right interaction terms are included. We then might apply **stepwise selection** to iteratively refine the model by removing unnecessary predictors. 

In practice, we use these methods together because no single technique gives a complete picture. By leveraging multiple approaches, we can make more informed decisions, ensure model robustness, and avoid pitfalls like overfitting or underfitting. In the next section, we will demonstrate how to apply these methods together using real data in **R** to guide the process of model selection in a cohesive, step-by-step manner.

# 6. Bringing It All Together
