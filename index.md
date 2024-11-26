
---
output:
  html_document: default
  word_document: default
  pdf_document: default
css: misc/style.css
---

<div class="banner">
  <h1>LINEAR MODELS:</h1>
  <h2>AIC MODEL SELECTION</h2>
</div>

_Created by Shai Stilman - November 2024_

--------

# Tutorial aims:

1. Understand why and when we perfrom AIC model selection.
2. Understand the evaluation metrics used in stepwise model selection.
3. Learn about `drop1()` function for model selection and how to intepret the output of it.
4. Learn about the `step()` function for model selection and how to intepret the output of it.
5. Learn how to these concepts to real problems in ecology and environmental sciences involving data through worked examples.

# Steps:

1. [**Introduction**](#Intro)
  - [Prerequisites](#Prerequisites)
  - [Data and Materials](#DataMat)
2. [**The AIC Value**](#aic)
3. [**AIC Model Selection**](#selection)
  - [Drop1](#drop)
  - [Step](#step)
4. [**Limitation to AIC Model Selection**](#lim)
5. [**Summary**](#summary)
6. [**Challenge**](#challenge)

### 1. Introduction
{: #Intro}

Building effective linear models is a key skill when working with complex datasets that contain many explanatory variables. Whether you're tackling environmental data, ecology studies, or any field with large and diverse datasets, selecting the right variables is crucial for creating models that are both accurate and easy to interpret. AIC (Akaike Information Criterion) model selection provides a powerful, systematic approach to help us achieve this balance, ensuring models are both simple and predictive.

This tutorial will walk you through the core concepts and practical applications of AIC-based model selection for linear models. By the end, you'll understand why and when AIC is used, and you'll gain hands-on experience with the `drop1()` and `step()` functions in R. These methods are particularly valuable for refining models in real-world scenarios, equipping you with skills for analyzing large, complex datasets.

---

## Prerequisites
{: #Prerequisites}

This tutorial is ideal for those with a basic or intermediate understanding of statistical analysis, particularly if you are curious about how R functions work in practice. If you're new to linear models in R or want to refresh your knowledge, check out the following tutorials on the Coding Club website to build your foundation:  
- [From Distributions to Linear Models](https://ourcodingclub.github.io/tutorials/modelling/)  
- [Introduction to Model Design](https://ourcodingclub.github.io/tutorials/model-design/)

While this tutorial focuses on using **R** to apply AIC model selection, the core principles are relevant in other programming environments too. To get the most out of the examples, you should be familiar with the following:  

- **Linear models** using the `lm()` function in R.
- Interpreting the **summary output** of linear models, with a basic understanding of key metrics such as the R-Squared value and Residual Standard Error (RSE) which can be found [here](https://feliperego.github.io/blog/2015/10/23/Interpreting-Model-Output-In-R) or [here](https://towardsdatascience.com/understanding-linear-regression-output-in-r-7a9cbda948b3).

This tutorial builds on your foundational linear modeling skills and guides you through the process of AIC model selection for both categorical and numerical variables.

---

## Data and Materials
{: #DataMat}

All the data you'll need for this tutorial can be found in `data` folder in [this GitHub repository](https://github.com/EdDataScienceEES/tutorial-shaistilman). We recommend downloading the data to your computer so you can follow along with the examples throughout the tutorial. This hands-on approach will help reinforce your understanding of the concepts covered.

For this tutorial, we'll be working with datasets from two R packages: `faraway` and `palmerpenguins`.

Source: [Faraway Package](https://cran.r-project.org/web/packages/faraway/index.html)
Source: [PalmersPeguins Package](https://cran.r-project.org/web/packages/palmerpenguins/index.html)

Both packages contain a variety of datasets for different applications. Our primary focus will be the `africa_data` dataset from the `faraway` package, which explores factors influencing military coups (denoted by `miltcoup`). The model will include several predictor variables such as:

- **Oligarchy** (`oligarchy`)
- **Political liberties** (`pollib`)
- **Number of political parties** (`parties`)
- **Population size** (`popn`)
- **Country size** (`size`)
- **Number of elections** (`numelec`)
- **Number of regimes** (`numregim`)

By using this dataset, you'll have the opportunity to apply AIC-based model selection to a real-world problem, exploring how these factors influence military coups.

---

# 2. Akaike Information Criterion (AIC)  
{: #aic}  

Up until now the main evaluation metric on how to make model-based descions has been the **p-value** and although this is a powerful metric in real-world scenarios it has limitations. In large datasets, p-values often identify statistically significant variables that have negligible practical relevance, leading to unnecessarily complex models. Additionally, p-values do not measure a variable’s importance or effect size and can become unreliable in the presence of multicollinearity, where overlapping effects between predictors obscure their individual contributions. Focusing solely on p-values risks overfitting, reducing a model's generalizability and predictive accuracy.  

To address these limitations, we must consider broader evaluation metrics that assess both the accuracy and complexity of a model. In this tutorial we will focus on the **Akaike Information Criterion (AIC)** and how it can be used in model selection. 

### So what is AIC?

The **AIC** is a widely used metric for evaluating model quality by balancing goodness of fit with model complexity. It helps identify models that explain the data effectively while avoiding unnecessary complexity. A **lower AIC value** indicates a model that achieves a better trade-off between accuracy and simplicity.  

<center><img src="{{ site.baseurl }}/figures/AIC_Chart.png" alt="Img" style="width: 100%; height: auto;"></center>

When comparing models, the one with the smallest AIC is typically preferred, as it represents the most efficient explanation of the data with minimal risk of overfitting. However, it is crucial to note that AIC values are **relative**, meaning they are only meaningful when comparing two models that describe the **same dataset**. Comparing AIC values across models built on different datasets or subsets of data would lead to misleading conclusions and we do not want that! Furthermore, while AIC favors simpler models, it should not be used in isolation. It complements other evaluation metrics, offering a holistic approach to model selection by ensuring the chosen model is both interpretable and generalisable. To compare our models using AIC, you need to calculate the AIC of each model. If a model is more than 2 AIC units lower than another, then it is considered significantly better than that model.



For those of you who are interested the formula is as follows:

<center><img src="{{ site.baseurl }}/figures/AIC_Formula.jpeg" alt="Img" style="width: 100%; height: auto;"></center>


where **L** is the log-likelihood estimate which the likelihood that the model could have produced your observed y-values. 

Note that the default **K **is always 2, so if your model uses one independent variable your **K** will be 3, if it uses two independent variables your **K** will be 4, and so on.

---
So now that we know what AIC is, lets have a look at how we can apply it when performing model selection!

---
# 3 AIC Stepwise Model Selection
{: #selection}

In this tutorial we will focus on **backwards stewpwise AIC model selection**, which is a systematic approach to refine a statistical model by removing explanatory variables from a large complex model based on the AIC. Stay tuned for next weeks tutorial on **forward stewpwise AIC model selection**. The goal is to strike a balance between a model that fits the data well and one that is not overly complex, thus the accuracy metric we focus on is AIC!


### When Would We Use AIC model selection?

We use model selection when we are modeling a large data set that has multiple potential explanatory variables. For example, a model on climate data might include variables such as temperature, precipitation, wind speed, solar radiation and many more! By selecting the most relevant variables, we can simplify the model while maintaining its predictive accuracy.

Our goal throughout this section is to **minimize the AIC**, as this reflects a model that explains the data well without being overly complex.

It is important to note that we only drop *one variable at a time* when perfoming AIC stepwise model selection. This is so we can isolate an explanatory variable impact on the model’s performance, ensuring clarity in how each variable contributes to explaining the response variable. The `drop1` and `step` function both illustrate this, showing the effect of dropping each variable while keeping others in the model. For example, in a model looking the effect of `location`, `sex` and `size` on `population` and  we find that the AIC decreases when dropping `sex` and it also decreased when we drop `size`, we cannot conclude both should be removed because the model retains `size` when assessing `sex`, and vice versa. Therefore, from this alone we do not know the affect of dropping both variables and further analysis must be done to decide if both variables should be dropped. This approach prevents misleading conclusions, preserves model structure, and ensures fair, accurate evaluations.

To begin with lets have a look at how we can do AIC model selection using the `drop1` function.

---
## 3.1 Drop 1
{: #drop1}

The `drop1` function in R is used during model selection to evaluate the impact of removing individual variables from a model. It one of the most commonly used function in stepwise model selection and it works by comparing the AIC values of models with and without each variable. We remember from Section 2 a **lower AIC** indicates a better model, as it suggests a better balance between fit and complexity and a **high Sum of Sq** indicates the predictor we are looking at significantly helps explain the response variable.


### What Does `drop1` Do?
  The `drop1` function evaluates what happens to the AIC if each variable in the model is removed one at a time. For each variable:
  - It calculates the AIC of the model without that variable.
  - It provides a table showing the AIC for all possible one-variable-removal models.



**The `drop1` Table**

<table border="1" style="background-color: #ffe6e6;">
  <thead>
    <tr>
      <th><b>Column</b></th>
      <th><b>What It Represents</b></th>
      <th><b>Why It's Important</b></th>
      <th><b>How Each Column Helps Track Impact</b></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Df (Degrees of Freedom)</b></td>
      <td>
        The number of parameters associated with each explanatory variable (i.e., the number of levels the explanatory variable has). It is important to remember that when we have categorical variables, they include a baseline in the intercept. For example, if a categorical variable has 3 levels, the first level is part of the baseline, leaving 2 levels (and thus 2 degrees of freedom).
      </td>
      <td>
        Indicates the complexity of the model. Predictors with higher Df contribute more parameters, increasing model complexity. Removing a predictor reduces the model's Df.
      </td>
      <td>
        Tracks how the model's complexity changes when a predictor is removed, helping assess if simplifying the model is justifiable.
      </td>
    </tr>
    <tr>
      <td><b>Sum of Squares (Sum of Sq)</b></td>
      <td>
        The variation in the response variable explained by each explanatory variable.
      </td>
      <td>
        Shows each explanatory variable’s contribution to explaining variance in the response. Larger values indicate stronger explanatory power.
      </td>
      <td>
        Highlights the explanatory variables with substantial impact, making them candidates for retention in the model (i.e., we don’t want to drop them!).
      </td>
    </tr>
    <tr>
      <td><b>Residual Sum of Squares (RSS)</b></td>
      <td>
        The amount of unexplained variance (errors) after the model is fitted without the explanatory variable.
      </td>
      <td>
        A lower RSS means the model fits the data better by explaining more variance. High RSS indicates a worse fit after removing an explanatory variable (i.e., we don’t drop it!).
      </td>
      <td>
        Tracks how much variance is left unexplained if an explanatory variable is removed, revealing its importance in reducing errors in the model.
      </td>
    </tr>
    <tr>
      <td><b>AIC</b></td>
      <td>
        The model's AIC after the explanatory variable has been removed.
      </td>
      <td>
        A lower AIC indicates a model that better balances accuracy and simplicity.
      </td>
      <td>
        Helps identify explanatory variables that improve the model’s AIC when removed, making them candidates for removal if the AIC improves.
      </td>
    </tr>
  </tbody>
</table>


### How Do We Interpret The Results?

 - If removing a variable reduces the AIC (i.e., leads to a lower AIC), it suggests that the model improves when that variable is dropped.  This may happen if the variable does not contribute significantly to the model or introduces unnecessary complexity.

 - If removing a variable increases the AIC, it indicates that the variable is important for the model, and dropping it would harm the balance between fit and complexity.

Therefore, we drop the variable that results in the lowest AIC, this may seem a bit counterintuitive as what we want is the lowest AIC model. However, the AIC value represents the AIC of the model **without** this variable and if this AIC is lower than the current model’s AIC it means that dropping that variable improves the overall model. Thus, in AIC model selection, this variable is removed because it leads to the greatest improvement in model quality according to the AIC.

Let's have a look at an example of `drop1` and look at how we can interpret the output it gives us. 

In this section we are analysing the `africa` dataset from the `faraway` package to explore factors influencing military coups (`miltcoup`). The model includes several predictors, such as `oligarchy`, political liberties (`pollib`), the number of parties (`parties`), population (`popn`), size (`size`), the number of elections (`numelec`), and the number of regimes (`numregim`). 

But how do we know which ones to use? Lets first consider the case where we do not have interaction terms.

### Example With No Interaction Term

To start off, open `RStudio`, and create a new script but clicking on `File/ New File/ R Script`. Once you have a new script open copy the following code to load in the data.

```r
# Purpose of the script
# Name, Email
# Data

# Set your working directory, set to the folder you want to save to, make sure its where you saved the data!
setwd("PATH_TO_YOUR_FOLDER")

#install and donwload necessary libraries
install.packages("faraway")
install.packages("palmerpenguins")

library(faraway)
library(palmerpenguins)
library(tidyverse)  # contains ggplot2 (data visualization) and other useful packages

# Import Data - for the purpose of this script the data is in the data folder of this repo so would be loaded in as:
load("data/africa.rda")  # Load the data

----
#however if we wanted to download the data from the package we would do the following:

#load the africa data
data("africa")
----

#view the first few rows of the data to get familiar with its structure
head(africa)
```


Now that the dataset is loaded, you're ready to dive into the tutorial and explore AIC model selection in action!

We start by fitting the model with all the potential explanatory variables:
```r
# Fit the model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + numelec + numregim, africa)
```

Yikes this is a large and complex model! 

We can use the `drop1` function to evaluate the effect of removing each explanatory variable from the model to see if according to the AIC value there is any explanatory variables we can remove from our model

```r
# Apply drop1
drop1(africa_lm)
```

We get the following output:

<center><img src="{{ site.baseurl }}/figures/drop1(africa_lm).png" alt="Img" style="width: 100%; height: auto;"></center>

#### What does this mean?

Lets look at what each column tells us:

**1. Df (Degrees of Freedom):**  
Indicates the degrees of freedom associated with each predictor. The degrees of freedom is the number of `levels` associated with each variable. This column tells us that:
- `oligarchy`: 1 degree of freedom because it is numeric.
- `as.factor(pollib)`: 2 degrees of freedom because it is a categorical variable with three levels (first level in baseline/intercept).

**2. Sum of Sq (Sum of Squares):**  
Represents the variation in `miltcoup` explained by the predictor. Removing a predictor reduces the explained variation:
- `oligarchy`: Explains a substantial 24.33 units of variation.
- `as.factor(pollib)`: Explains 7.35 units of variation.  

**3. RSS (Residual Sum of Squares):**  
The remaining unexplained variation in `miltcoup` after removing the predictor. Smaller RSS values indicate a better-fitting model:
- `<none>`: The full model has an RSS of **57.249**.
- `oligarchy`: Removing this predictor increases RSS to **81.575**, indicating it is crucial for the model.
- `numelec`: Removing this predictor results in an RSS of **58.259**, showing a minimal increase.

**4. AIC (Akaike Information Criterion):**  
Evaluates model quality by balancing fit and complexity. Lower AIC values indicate better models:
- `<none>`: The full model has an AIC of **31.009**.
- `oligarchy`: Removing this predictor raises the AIC to **43.882**, indicating its importance.
- `numregim`: Removing this predictor slightly reduces the AIC to **29.418**, suggesting it may be worth considering for removal.

#### So What are our Key Insights?

**1. `oligarchy` is critical.**  
Removing `oligarchy` leads to a large increase in RSS (from **57.249** to **81.575**) and a substantial worsening of AIC (from **31.009** to **43.882**). This indicates `oligarchy` is essential for explaining `miltcoup`. 

**2. `numregim` may be removable.**  
Removing `numregim` slightly reduces AIC (from **31.009** to **29.418**), suggesting it contributes little to the model's performance. The small increase in RSS further supports this.

**3. `as.factor(pollib)` and `parties` are moderately important.**  
Both variables contribute noticeable sums of squares (7.35 and 4.01, respectively). However, removing them increases AIC slightly, indicating they are somewhat useful but not as critical as `oligarchy`.

**4. `popn`, `size`, and `numelec` have minimal impact.**  
These predictors have the smallest AIC changes when removed (from **31.009** to **30.308**, **29.726**, and **29.744**, respectively). Their contributions to RSS are also modest, making them potential candidates for exclusion.

#### So What Are Our Next Steps?
Based on the `drop1` results, the next step might involve:
- Retaining `oligarchy` as a key predictor.
- Considering the removal of `numregim` to simplify the model while improving AIC.
- Further assessing the importance of `popn`, `size`, and `numelec` to determine if they can also be excluded.


So now we have seen an in depth example without an interaction term lets look at an example with one.

### Example With an Interaction Term

What happens if we have an interacton term? Well lets say we had model with an interaction between `size` and `gender` (i.e, `size:gender`), instead of having 3 variables (size, gender, interaction) `drop1` only looks at the interaction of our two terms, `size:gender`.  This is because, it evaluates the impact of dropping *one variable at a time*. For a model that includes an interaction term, such as `size:gender`, it wouldn’t make sense to drop `gender` (or `size`) while keeping the interaction term (`size:gender`) in the model. This is because the interaction term inherently depends on the individual factors (`size` and `gender`) to make sense. If, for example, `gender` was removed while retaining `size:gender`, the model would break, as the interaction term cannot exist without its components. Therefore, `drop1` ensures logical consistency by assessing only the effect of removing `size:gender` as a whole, while leaving its individual factors intact. This approach aligns with the purpose of `drop1`, which isolates the impact of removing one element at a time, ensuring the model structure remains valid and the results meaningful.

Let's have a look at an example, what if our miltary coup model had an interaction term:

```r
#define linear model
africa_interact_lm <- lm(miltcoup ~ oligarchy*parties + as.factor(pollib) + popn + size
                         + numelec + numregim, africa_data)
```

Now we have an interaction between oligarchy and the number of parties. If we applied `drop1` to this model we would get a slighly different output to the table we had before:


```r
#apply drop1
drop1(africa_interact_lm)
```
We get the following output:

<center><img src="{{ site.baseurl }}/figures/drop1(africa_interact_lm).png" alt="Img" style="width: 100%; height: auto;"></center>

#### So What Are Our Key Insights?

**1. The interaction term `oligarchy:parties` is moderately important.**  
Removing `oligarchy:parties` increases the RSS from **51.328** to **57.249** and worsens the AIC from **28.424** to **31.009**. This indicates the interaction contributes meaningfully to the model, although not as critically as some individual variables.

**2. `as.factor(pollib)` is valuable.**  
Removing `as.factor(pollib)` increases the RSS to **57.795** and raises the AIC to **29.407**, showing that this variable contributes a substantial amount of variation and should likely be retained.

**3. `popn` is moderately useful.**  
Removing `popn` raises the RSS to **55.358** and slightly worsens the AIC to **29.599**, suggesting that while it adds some value to the model, it is not as crucial as other terms.

**4. `size` and `numregim` may improve the model if removed.**  
- Removing `size` reduces AIC significantly (from **28.424** to **26.866**), while barely increasing the RSS, suggesting it adds little explanatory power.  
- Similarly, removing `numregim` lowers AIC (to **26.935**) with minimal impact on RSS, making it another candidate for removal.

**5. `numelec` has a modest impact.**  
Removing `numelec` increases RSS to **53.719** and slightly worsens AIC to **28.336**, suggesting its contribution is modest but not negligible.

#### So What Are Our Next Steps?
Based on the `drop1` results, the following steps are recommended:  
- Retain the interaction term `oligarchy:parties` and `as.factor(pollib`, as they contribute significantly to the model.  
- Consider removing `size` and `numregim` to simplify the model while improving AIC.  
- Reassess `popn` and `numelec` to determine their relevance in the context of overall model performance.  

---

Tada !! Now we know that we can use `drop1` function in R and understand its ouput for both interaction and no interaction models for model selection! 

Since we only remove one term at a time (focusing on the term whose removal leads to the biggest reduction in AIC), applying the `drop1` function repeatedly is necessary until no further improvements in AIC can be made. However, this process can become tedious and inefficient when dealing with large models containing many variables. That’s where the `step` function comes to the rescue!


---
## 3.2 Step
{: #step}  

The `step` function streamlines the process by automating the stepwise approach. It iteratively adds or removes variables to optimize the model based on AIC. Essentially, the `step` function handles the repeated application of `drop1` for us, outputting the final model where removing any explanatory variable would increase the AIC.


### How Does The `step` Function Work?

The `step` function in R automates stepwise model selection by evaluating the AIC for all deletions of predictors at each step. Here's how it works:
1. The function starts with our initial model with lots of explanatory variables in it.
2. It iteratively evaluates potential models by removing each variable and calculating the AIC, selecting the model with the **lowest AIC** to carry forward.
3. It repeats this process untill removing variables reduces the AIC, i.e we have the 'best' model accoridng to AIC.
   

### How Do We Interpret The Results? 

For each iteration the `step` function creates a summary table which shows the details of each model, the models are listed from **lowest to highest** AIC. The `<none>` row shows the current model’s performance (AIC, RSS, etc.) before any changes (i.e., before any predictor is removed), it serves as a reference point for comparing the impact of removing predictors and helps assess how each variable removal affects the model.       

Each column tells us something different for the model we are looking at:


<table border="1" style="background-color: #ffe6e6;">
  <thead>
    <tr>
      <th><b>Column</b></th>
      <th><b>What It Represents</b></th>
      <th><b>Why It's Important</b></th>
      <th><b>How Each Column Helps Track Impact</b></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Df (Degrees of Freedom)</b></td>
      <td>
        The number of parameters (or pieces of information) associated with each predictor minus 1.
      </td>
      <td>
        Indicates the complexity of the model. A predictor with higher Df typically contributes more parameters to the model. The removal of a predictor reduces the model's Df.
      </td>
      <td>
        Shows how the number of parameters changes when a predictor is added or removed.
      </td>
    </tr>
    <tr>
      <td><b>Sum of Squares (Sum of Sq)</b></td>
      <td>
        The amount of variation explained by each predictor in the model.
      </td>
      <td>
        Shows the contribution of each predictor to explaining the variance in the dependent variable. Larger values indicate greater contribution.
      </td>
      <td>
        Indicates how much variation is explained by a predictor. A larger value means the predictor contributes more to explaining the response variable.
      </td>
    </tr>
    <tr>
      <td><b>Residual Sum of Squares (RSS)</b></td>
      <td>
        The amount of unexplained variance (errors) after fitting the model.
      </td>
      <td>
        A lower RSS indicates a better-fitting model because the model explains more of the variance in the data. The goal is to minimize RSS.
      </td>
      <td>
        Reveals how much unexplained variance remains after fitting the model. A lower RSS suggests better model fit.
      </td>
    </tr>
    <tr>
      <td><b>Akaike Information Criterion (AIC)</b></td>
      <td>
        A measure used for model selection that balances model fit and complexity (number of parameters).
      </td>
      <td>
        A lower AIC indicates a better model that balances fit and complexity. The step() function selects models based on the lowest AIC.
      </td>
      <td>
        The primary measure for model selection. The goal is to minimize AIC by selecting the model with the best balance between complexity and fit.
      </td>
    </tr>
  </tbody>
</table>

 **Final Model**:
   - After the iterations, the final model is displayed, which has the **lowest AIC** and is considered the best model based on the AIC criterion.
   - After the function makes a selection, the coefficients of the final model show the impact of each predictor on the outcome variable.

**Key Points for Interpretation**  
- *Lower AIC is better:* The goal is to minimize the AIC by selecting variables that improve the balance between fit and complexity.
- At each iteration we only remove **one** variable to maintain control over model complexity, accurately assess each predictor’s impact, and prevent overfitting. This iterative approach ensures that the model is gradually simplified while preserving its predictive power. By removing variables one by one, the process allows for careful evaluation of how each predictor affects the model's performance (AIC and fit), avoids drastic changes that could harm the model, and ensures computational efficiency.
- The process stops when *no variable removal* reduces the AIC further.  
- *Removed variables:* Variables whose exclusion lowers the AIC were likely not contributing significantly to the model. 


### Why Would We Use `step` Function?  
The `step` function is particularly useful when dealing with a large number of predictors, as it automates the model selection process. It ensures a systematic evaluation of the impact of each variable, saving time and effort compared to manually using `drop1`. However, caution is needed to avoid overfitting or underfitting, as the process is driven solely by AIC without considering domain knowledge or practical significance.  
 
Lets have a look at some examples with and without interaction terms! Lets continue with the `africa` data from the faraway package about the miltary coups and politics in sub-Saharan Africa. 
 
### Example Without an Interaction Term

We first look at our linear model without interaction terms:

```r
#define linear model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size
+ numelec + numregim, africa_data)
```

This is a huge model with lots of predictors. How can we *efficiently* make sure that all these predictors are necessary and we are not overfitting? The `step` fucntion!

Lets apply the `step` function and see what happens:

```r
#apply step()
step(africa_lm)
```

We get the following output:

<center><img src="{{ site.baseurl }}/figures/step(africa_lm).png" alt="Img" style="width: 100%; height: auto;"></center>

Try not be put off by how large an output this is as it is pretty straightforward to interpret!
The output of the `step()` function is a result of **stepwise model selection** using AIC. The goal is to iteratively remove predictors from the model (or add them, if necessary) to minimise the AIC, which balances model fit and complexity. Here's a breakdown of each part of the output:

#### Step 1: Initial Model:

Before we see our summary table we have the following output:
```r
Start:  AIC=31.0
miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + numelec + numregim
```

 This tell us that our starting model with all the predictors: `oligarchy`, `as.factor(pollib)`, `parties`, `popn`, `size`, `numele`, and `numregim`, has an AIC value of 31.01.

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
tells us what each model with the specified variable does to our models Sum of Squares, RSS and AIC. Refer to the table above for a more in depth explanation of each column.
Based on the output we can see that:
- Removing `numregim` decreases AIC from **31.01** to **29.42**, which suggests that removing `numregim` improves the model.
- Removing `oligarchy` leads to a much worse AIC of **43.88**, indicating that it’s an important predictor.

#### Step 2: New Model After Removing `numregim`

Before we see our next summary table we have the following output:
```r
Step:  AIC=29.42
miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + numelec
```
This tells that the updated model after removing `numregim` has an AIC of **29.42**, and what variables it contains. This model becomes our new basline model and is now what the `<none>` variable represents.

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
This `Coefficients` table shows the estimated effect of each predictor on the dependent variable `miltcoup`, similar to the `summary` output we've seen before.

---

What happens if we have an interaction term? The exact same thing as the `drop1` function, the `step` function treats the interaction term as a variable in itself and ignores the components of it for the exact same reason! 

### Example With an Interaction Term

Lets have a look at an example think back to our `africa_interact_lm` model where we assumed there was interaction between `oligarchy` (the number years country ruled by military oligarchy from independence to 1989) and `parties` (the number of legal political parties in 1993).

```r
africa_interact_lm <- lm(miltcoup ~ oligarchy*parties + as.factor(pollib) + popn + size
+ numelec + numregim, africa_data)
```
This is a very complex model with lots of predictors. Lets apply the  `step` function to reduce our model so we can be sure that all these predictors are necessary and we are not overfitting.

```r
#apply step()
step(africa_interact_lm)
```
This gives us the following output:

<center><img src="{{ site.baseurl }}/figures/step(africa_lm_interact).png" alt="Img" style="width: 100%; height: auto;"></center>

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

The `step` function then  removes `size` from the model and repeats this process. This is repeated untill we get to our final model in exactly the same way as our previous example.

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
Now we can succesfully perfom AIC Model Selection! 

Well done for making it this far, before we wrap up there is some important notes we need to cover about the AIC value.

---
# 4. Limitation of AIC Model Selection
{: #lim}  
<center><img src="{{ site.baseurl }}/figures/AIC Warning.jpeg" alt="Img" style="width: 100%; height: auto;"></center>

AIC (Akaike Information Criterion) is a useful tool to compare different models, but it’s important to remember that it’s not a measure of how good a model is on its own. Instead, it helps us find the best balance between a model’s simplicity (fewer variables) and how well it fits the data. However, just because a model has a low AIC doesn’t mean it’s the best overall—sometimes the "best" model according to AIC might still not explain things well or give us meaningful results.

It's also crucial not to drop variables from a model just to make the AIC look better. For example, if we're studying how size is affected by gender, removing "gender" just because it lowers the AIC could lead us to miss out on important information. Dropping variables without thinking about the bigger picture could mean the model doesn't answer the questions we set out to explore.

That’s why we should always use AIC alongside other measures, like RSE, R-Squared, and F-statistics, to make sure our model truly explains the data and helps us answer our research questions in the best way possible. AIC gives us helpful clues, but it’s only part of the story!

---
# 5. Summary
{: #summary}  
In this tutorial, we explored the AIC value and how it can be applied in model selection. It helps us find the right balance between model accuracy and simplicity, making it especially useful in fields like ecology and environmental sciences where datasets are often large and complex.

#### Key Points:
1. **Why AIC?**
   - AIC allows us to identify the best model by comparing different options based on how well they explain the data and how simple they are. A model with a lower AIC is preferred because it offers the best combination of fit and simplicity.
   - Remember, AIC values are **relative**, you can only compare them when the models describe the same dataset, and they only tell **part** of the story!

2. **AIC Stepwise Model Selection**
   - **The Drop1 Function**: This function evaluates what happens if we remove each variable from the model. It shows us which variables are crucial for the model’s quality, helping us decide which ones to keep.
   - **The Step Function**: This function automates this process, adjusting the model by adding or removing variables to find the one with the lowest AIC. It saves time and effort by systematically narrowing down the best model.

3. **When to Use AIC**
   - AIC is especially helpful when working with large datasets that have many potential explanatory variables. The goal is to find a model that explains the data well without including too many unnecessary details.

4. **Limitations of AIC**
   - AIC is a useful tool, but it’s not the only measure of how good a model is. It’s important to also look at other metrics, like R-Squared and F-statistics, to make sure the model truly fits the data and answers your research questions.
   - Don’t just drop variables from your model because it makes the AIC lower; this can lead to missing out on important information. Always think carefully about what each variable contributes to your model.

#### Conclusion:
AIC is a great tool for selecting models, but it’s not the whole picture. Using **drop1** and **step** functions in R helps refine your model by keeping the most important variables and removing those that aren’t contributing much. However, it’s crucial to think about your research questions and use other evaluation methods to ensure your model is meaningful and reliable.

This tutorial equipped you with the skills to:

- Load in data from packages, namely the `faraway` package.
- What the AIC value is and what it represents.
- When it is appropriate to use AIC model selecton.
- How to perfrom AIC model selection using `drop1` and `step` functions.
- How to interpret the output from `drop1` and `step` functions.
- The limitations of AIC.

We hope this has demonstrated the power of model selection in refining complex, long models, similar to the extensive ecological datasets you may encounter in your future!

---
# 6. Challenge 
{: #challenge}  
You have been asked to research what effects the body mass of penguins! Your research partner has extracted the `penguins` data from the palmerspenguin package and has cleaned it up. They then constructed the following model to answer the research question.

```r
full_model <- lm(body_mass_g ~ species*flipper_length_mm + island*sex + bill_length_mm + bill_depth_mm, data = penguins_clean)
```

This model looks complex and you believe it can be simplified. Using AIC model selection decide *based off the AIC value* which terms should be kept in the model. Compare the summaries of the ful model and the final model you've selected, has the R-Squared and RSE value improved?


 *note that there is multiple correct answers based on your own philsophy of model selection*


<details>
  <summary>Click here for the answer</summary>
  
  <p>Here’s the R code to define the model:</p>

  <pre><code class="r">
  # Define research partners model
  full_model <- lm(body_mass_g ~ species*flipper_length_mm + island*sex + bill_length_mm + bill_depth_mm, data = penguins_clean)

  # Start by looking at the summary so we can find the R^2 and RSE
  summary(full_model)
  # R^2 = 0.8794, Adjusted R^2 = 0.8749, RSE = 284.8
  </code></pre>

  <h4>Method 1: Drop1</h4>
  <pre><code class="r">
  # Method 1: Drop1
  drop1(full_model)
  # This tells us that dropping species:flipper_length_mm results in a slightly reduced AIC, therefore we should drop it
  
  # Define new model 
  new_model <- lm(body_mass_g ~ species + flipper_length_mm + island*sex + bill_length_mm + bill_depth_mm, data = penguins_clean)
  drop1(new_model)
  
  # No terms should be dropped!
  summary(new_model)
  # R^2= 0.8792, Adj R^2 = 0.8755, RSE = 284.1
  </code></pre>

  <h4>Method 2: Step</h4>
  <pre><code class="r">
  # Method 2: Step
  step(full_model)
  # Drops species:flipper_length_mm
  
  # New model
  step_model <- lm(formula = body_mass_g ~ species + flipper_length_mm + island*sex + bill_length_mm + bill_depth_mm, data = penguins_clean)
  
  # Summary
  summary(step_model)
  # R^2 = 0.8792, Adj R^2 = 0.8755, RSE = 284.1
  </code></pre>

  <p>Both methods result in the same final model. We see that the R-Squared and the RSE have <em>marginally improved</em>. This tells us that our model performs the same as our research partner's model and therefore, probably doens't need refined via AIC model selection. However, we still have a high AIC and thus we should probably narrow down our research questions and investigate if specific explanatory variables affect body mass.</p>

</details>



