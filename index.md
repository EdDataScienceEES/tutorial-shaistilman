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

1. Understand why and when we perfrom AIC model selection.
2. Understand the evaluation metrics used in stepwise model selection.
3. Learn about `drop1()` function for model selection and how to intepret the output of it.
4. Learn about the `step()` function for model selection and how to intepret the output of it.
5. Learn how to these concepts to real problems in ecology and environmental sciences involving data through worked examples.

# Steps:

1. [**Introduction**](#Intro)
  - [Prerequisites](#Prerequisites)
  - [Data and Materials](#DataMat)
2. [**AIC Value**](#eval)
  - [Meaning](#meaning)
  - [Limitations](#Limitations)
3. [**AIC Model Selection**](#step)
  - [Drop1](#one)
  - [Step](#Step)
4. [**Summary**](#Summary)
5. [**Challenge**](#Challenge)

---
# 1. Introduction
{: #Intro}

Building effective linear models often involves navigating complex datasets with numerous explanatory variables. Selecting the most relevant variables is essential to ensure models remain interpretable, accurate, and robust, especially in fields like ecology and environmental sciences where data is often large and multifaceted. AIC (Akaike Information Criterion) model selection is a valuable tool for this purpose, providing a systematic approach to refine models by balancing simplicity and predictive performance.

This tutorial will guide you through the principles and application of AIC-based model selection for linear models. By the end, you will understand why and when to perform AIC model selection, learn to interpret key evaluation metrics, and gain hands-on experience with drop1() and step() functions in R. These methods will be applied to real-world problems in environmental sciences, equipping you with practical skills for addressing challenges in big data analysis.



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

Now we are ready to dive into the this tutorial!

---

# 2. Akaike Information Criterion (AIC)  
{: #AIC}  


Up until now the main evaluation metric on how to make model-based descionshas been the **p-value** and although this is a powerful metric in real-world scenarios it has limitations. In large datasets, p-values often identify statistically significant variables that have negligible practical relevance, leading to unnecessarily complex models. Additionally, p-values do not measure a variable’s importance or effect size and can become unreliable in the presence of multicollinearity, where overlapping effects between predictors obscure their individual contributions. Focusing solely on p-values risks overfitting, reducing a model's generalizability and predictive accuracy.  

To address these limitations, we must consider broader evaluation metrics that assess both the accuracy and complexity of a model. In this tutorial we will focus on the **Akaike Information Criterion (AIC)** and how it can be used in model selection. 

### So what is AIC?

The **AIC** is a widely used metric for evaluating model quality by balancing goodness of fit with model complexity. It helps identify models that explain the data effectively while avoiding unnecessary complexity. A **lower AIC value** indicates a model that achieves a better trade-off between accuracy and simplicity.  

When comparing models, the one with the smallest AIC is typically preferred, as it represents the most efficient explanation of the data with minimal risk of overfitting. However, it is crucial to remember that AIC values are relative and can only be compared across models fitted to the same dataset.  Furthermore, while AIC favors simpler models, it should not be used in isolation. It complements other evaluation metrics, offering a holistic approach to model selection by ensuring the chosen model is both interpretable and generalisable.


---
So now that we know what AIC is, lets have a look at how we can apply it when performing model selection!

---
# 3 AIC Model Selection
{: #selection}

In this tutorial we will focus on stewpwise AIC model selection, which is a systematic approach to refine a statistical model by either adding or removing predictors based on a specific evaluation criterion. The goal is to strike a balance between a model that fits the data well and one that is not overly complex, thus the accuracy metric we focus on is AIC!

### When would we use AIC model selection?

We use model selection when we are modelling a large data-set that has multiple potential explanatory variables, for example a model on climate data

Our goal throughout this section is to **minimise the AIC**, this reflects a model that explains the data well without being overly complex.

To begin with lets have a look at how we can do this using the `drop1` function.

---
## 3.1 Drop 1
{: #drop1}

The `drop1` function in R is used during model selection to evaluate the impact of removing individual variables from a model. It one of the most commonly used function in stepwise model selection and it works by comparing the AIC values of models with and without each variable. We remeber from section 3 a **lower AIC** indicates a better model, as it suggests a better balance between fit and complexity and a **high Sum of Sq** indicates the predictor we are looking at significantly helps explain the response variable.

**What `drop1` Does**  
The `drop1` function evaluates what happens to the AIC if each variable in the model is removed one at a time. For each variable:
   - It calculates the AIC of the model without that variable.
   - It provides a table showing the AIC for all possible one-variable-removal models.

**The `drop1` Table**

| **Column**                     | **What It Represents**                                                                                                                                   | **Why It's Important**                                                                                                                                                           | **How Each Column Helps Track Impact**                                                                                                                                               |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Df (Degrees of Freedom)**     | The number of parameters associated with each explanatory variable (i.e, the number of levels the explanatory variable has).  It is important to remeber that when we have categorical variables in our model they get included in our intercept to represent a baseline predictor that we compare our other predictors to. For example if we had a categorical variable with 3 levels (there is 3 different types of this categorical variable) beacuse the first level (first type of variable) gets included in the baseline, then our categorical variable has now only got 2 levels and therefore 2 degrees of freedom.
                                                              | Indicates the complexity of the model. Predictors with higher Df contribute more parameters, increasing model complexity. Removing a predictor reduces the model's Df.           | Tracks how the model's complexity changes when a predictor is removed, helping assess if simplifying the model is justifiable.                                                        |
| **Sum of Squares (Sum of Sq)**  | The variation in the response variable explained by each explanatory variable.                                                                                       | Shows each explanatory variable’s contribution to explaining variance in the response. Larger values indicate stronger explanatory power.                                                   | Highlights the explanatory variables that have a substantial impact on explaining the response variable, making them candidates for retention in the model (i.e, we dont want to drop them!).                                      |
| **Residual Sum of Squares (RSS)** | The amount of unexplained variance (errors) after the model is fitted without the explanatory variable.                                                              | A lower RSS means the model fits the data better by explaining more variance. High RSS indicates a worse fit after removing an explanatory variable (i.e, we dont want to drop it!).                                         | Tracks how much variance is left unexplained if an explanatory variable is removed, revealing the explanatory variable’s importance in reducing errors in the model.                                         |
| **AIC** | This value represets the model's AIC after the explanatory variable has been removed.                                                               | A lower AIC indicates a model that better balances accuracy and simplicity.                                                  | Helps identify explanatory variable that improve the model's AIC when removed and that therefore, we should consider removing.    |

**How to Interpret the Results**  
   - If removing a variable reduces the AIC (i.e., leads to a lower AIC), it suggests that the model improves when that variable is dropped. This may happen if the variable does not contribute significantly to the model or introduces unnecessary complexity.
   - If removing a variable increases the AIC, it indicates that the variable is important for the model, and dropping it would harm the balance between fit and complexity.

Therefore, we drop the variable that results in the lowest AIC, this may seem a bit counterintuitive as what we want is the lowest AIC model. However, the AIC value represnets the AIC of the model **without** this variable and if this AIC is lower than the current model’s AIC it means that dropping that variable improves the overall model. Thus, in stepwise regression, this variable is removed because it leads to the greatest improvement in model quality according to the AIC.

Lets have a look at an example of `drop1` and look at how we can interpret the output it gives us. 

In this example we are analysing the `africa_data` dataset from the `faraway` package to explore factors influencing military coups (`miltcoup`). The model includes several predictors, such as `oligarchy`, political liberties (`pollib`), the number of parties (`parties`), population (`popn`), size (`size`), the number of elections (`numelec`), and the number of regimes (`numregim`). 

But how do we know which ones to use? Lets first consider the case where we dont have interaction terms.

### Example With No Interaction Term

We start by fitting the model with all the potential explanatory variables:
```r
# Fit the model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + numelec + numregim, africa_data)
```

Yikes this is a large and complex model! 

We can use the `drop1` function to evaluate the effect of removing each explanatory variable from the model to see if according to the AIC value there is any explanatory variables we can remove from our model

```r
# Apply drop1
drop1(africa_lm)
```

We get the following output:

```
Single term deletions

Model:
miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size + 
    numelec + numregim
                  Df Sum of Sq    RSS    AIC
<none>                         57.249 31.009
oligarchy          1   24.3257 81.575 43.882
as.factor(pollib)  2    7.3485 64.598 32.081
parties            1    4.0115 61.261 31.854
popn               1    1.7987 59.048 30.308
size               1    0.9849 58.234 29.726
numelec            1    1.0103 58.259 29.744
numregim           1    0.5599 57.809 29.418
```

### What does this mean?

Lets look at what each collumn tells us:

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

### So What are our Key Insights?

**1. `oligarchy` is critical.**  
Removing `oligarchy` leads to a large increase in RSS (from **57.249** to **81.575**) and a substantial worsening of AIC (from **31.009** to **43.882**). This indicates `oligarchy` is essential for explaining `miltcoup`.

**2. `numregim` may be removable.**  
Removing `numregim` slightly reduces AIC (from **31.009** to **29.418**), suggesting it contributes little to the model's performance. The small increase in RSS further supports this.

**3. `as.factor(pollib)` and `parties` are moderately important.**  
Both variables contribute noticeable sums of squares (7.35 and 4.01, respectively). However, removing them increases AIC slightly, indicating they are somewhat useful but not as critical as `oligarchy`.

**4. `popn`, `size`, and `numelec` have minimal impact.**  
These predictors have the smallest AIC changes when removed (from **31.009** to **30.308**, **29.726**, and **29.744**, respectively). Their contributions to RSS are also modest, making them potential candidates for exclusion.

### So What Our Are Next Steps
Based on the `drop1` results, the next step might involve:
- Retaining `oligarchy` as a key predictor.
- Considering the removal of `numregim` to simplify the model while improving AIC.
- Further assessing the importance of `popn`, `size`, and `numelec` to determine if they can also be excluded.


So now we have seen an in depth example without an interaction term lets look at an example with one.

### Example With an Interaction Term

What happens if we have an interacton term? Well lets say we had an interaction between `size` and `gender` (i.e, `size:gender`), instead of having 3 variables (size, gender, interaction) `drop1` only looks at the interaction of our two terms, `size:gender`. 

When a model includes an interaction term, like `size:gender`, it means we’re looking at how the combination of `size` and `gender` affects the outcome, not just their individual effects. The `drop1` function focuses on removing this combination effect (the interaction) without touching the individual factors (`size` and `gender`) because the interaction depends on those individual factors to make sense. Removing just the interaction helps us see whether the combination adds anything meaningful to the model, while still keeping the basic effects of `size` and `gender`. This ensures the results remain logical and easy to interpret.


What if our miltary coup model had an interaction term:

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




---

Tada now we know that we can use `drop1` function in R and understand its ouput for both interaction and no interaction models for model selection! 

But what if we have a big model with lots of different variables, like our miltary coups and politics in sub-Saharan Africa data example, using `drop1` over and over would be very tedious and not very efficient. This is where the `step` function comes in!


---
## 3.2 Step

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
# 4. Limitation of AIC Model Selection



## Example

In this example, we use the penguins_clean dataset, which is a cleaned version of the `penguins` data from the `palmerpenguins package`. 

In this example we will evaluate and refine the following **full model** 

```r
full_model <- lm(body_mass_g ~ species*flipper_length_mm + island*sex, data = penguins_clean)
```

### Method 1. Summary

We begin by examining our model's summary.

```r
summary(full_model)
```

![ah](https://github.com/EdDataScienceEES/tutorial-shaistilman/blob/master/figures/summary(full_model).png)

The summary of the full_model shows the results of fitting a linear regression model predicting body mass (body_mass_g) based on the factors species, flipper_length_mm, island, and sex, including their interactions. 


The summary provides key insights into the significance of each predictor in the model:

Significant predictors:
flipper_length_mm (p < 0.001) and sexmale (p < 2e-16) are strong predictors of body mass.
The interaction term island:sexmale is also significant (p = 0.0299), indicating that the relationship between body mass and the island varies by sex.
Non-significant predictors:
speciesChinstrap and islandTorgersen have high p-values, suggesting they don’t have a significant effect on body mass in this model.
Model performance:
Residual Standard Error (RSE) of 293.6 means that, on average, the model’s predictions are off by 293.6 grams. Whether this error is acceptable depends on the context and required precision.
The R-squared value of 87.11% indicates that the model explains a large portion of the variance in body mass, suggesting it is a good fit for the data.
The F-statistic of 217.6 with a p-value < 2.2e-16 indicates the overall model is highly significant.


We that:
- Significant predictors include flipper_length_mm (p < 0.001) and sexmale (p < 2e-16), indicating a strong impact on body mass. The interactions between island:sexmale are also significant (p = 0.0299). However, predictors like speciesChinstrap and islandTorgersen show high p-values, suggesting they do not significantly affect the outcome.
- The Residual Standard Error (RSE) of 293.6 indicates  the model's predictions are, on average, off by 293.6 grams. Whether this is acceptable depends on the scale of the data and the level of accuracy you need. If predicting penguin body mass with an error of around 293 grams is considered tolerable in your analysis, it might be acceptable. However, if more precise predictions are required, this could be considered a sign that the model needs improvement.
- The overall model is highly significant (F-statistic = 217.6, p < 2.2e-16).
- The model explains 87.11% of the variance in body mass (R-squared = 0.8711), which suggests this model is a relevatively good fit for the data.

### Method 2. Drop1

Next, we use the `drop1` function to perform a stepwise model selection:

```r
drop1(full_model)
```
This output suggests the interaction term `species:flipper_length_mm` has the smallest impact on the model and removing it leads to a slight improvement in AIC. However, because we have an interaction term, `drop1` only looks at these interaction terms and as such doesn't give us infromation on anything apart from the interaction term. Therefore, in this example it might be worth to apply the `step` function.


However, since drop1 only evaluates interaction terms, it doesn’t provide a full picture of which terms might be unnecessary. For a more comprehensive model refinement, we turn to the step function.

### Method 3. Step & One-Way ANOVA

```r
step(full_model)
```
In this output, species, flipper_length_mm, and the interaction term island:sex are kept, while other terms like `species:flipper_length_mm` are removed based on their contribution to AIC.

This tells us the saem infromation as `drop1` but now we have confirmed that this varaible should be removed, lets have a look at our new models summary:

```r
step_model <- lm(body_mass_g ~ species + flipper_length_mm + island*sex, penguins_clean)
summary(step_model)
```
We then look at the summary(step_model) output provides key insights into the fitted linear regression model. The model explains 87.08% of the variance in body mass (R-squared = 0.8708), with significant predictors including speciesGentoo, flipper_length_mm, and sexmale. The p-values for these predictors are very low, indicating they significantly affect body mass. On the other hand, predictors like island and islandTorgersen are not statistically significant, suggesting they can be removed to simplify the model. The overall model is highly significant, with a very low p-value for the F-statistic, confirming its strong predictive power.

Now we can then apply the anova function to our new model to understand if island variabke should be rempved
```r
anova(step_model)
```

The anova(step_model) output provides an analysis of variance (ANOVA) table for the fitted model, which helps assess the significance of each predictor in explaining the variance in body mass (body_mass_g):

species and flipper_length_mm are highly significant, with very low p-values (< 2e-16), indicating that they have a strong effect on body mass.
sex is also significant, with a p-value less than 2e-16, showing it is an important predictor.
island has a much higher p-value (0.18592), suggesting it is not a significant predictor and may not be contributing much to the model.
island:sex shows a significant interaction effect (p = 0.01095), meaning the relationship between island and body mass depends on the sex of the penguins.
Residuals (unexplained variance) account for 27,806,131 of the total sum of squares, and the residual mean square is 85,821.
The stars next to the p-values indicate significance: *** for highly significant predictors (p < 0.001), * for moderately significant predictors (p < 0.05), and no stars for predictors with no significant effect.

In summary, the ANOVA table shows that species, flipper_length_mm, sex, and the interaction of island and sex are significant predictors, while island alone is not.


### Method 4: 2-Way ANOVA

If were intersted in deciing whether a modelw ithout interaction terms is betetr than a model with inertaction terms we could use 2-way ANOVA allows us to compare two models (in this case, the full model with interaction terms and a reduced model without interaction terms) to see if the interaction terms improve the model fit significantly. It can help evaluate whether the complexity added by interaction terms is justified.

```r
anova(full_model, reduced_model)
```
This output shows that removing the interaction terms from the full model results in a significant increase in RSS (which suggests that the interactions are important), but the p-value for the reduction is just above 0.05, meaning the improvement is marginal.

In summary accoridng ot all of our methods our final model should be 

# 4. Summary 



These methods can be used together or separately depending on the stage of model selection:


Stepwise selection might be used first to identify a good baseline model.
Drop1 and 1-way ANOVA can then be applied to further refine the model.
2-way ANOVA provides a final check on whether removing interaction terms leads to a significant loss in model fit.
