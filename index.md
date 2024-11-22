

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
2. [**The AIC Value**](#eval)
3. [**AIC Model Selection**](#step)
  - [Drop1](#one)
  - [Step](#Step)
4. [**Limitation to AIC Model Selection**](#lim)
5. [**Summary**](#Summary)
6. [**Challenge**](#Challenge)

---
# 1. Introduction
{: #Intro}

Building effective linear models often involves navigating complex datasets with numerous explanatory variables. Selecting the most relevant variables is essential to ensure models remain interpretable, accurate, and robust, especially in fields like ecology and environmental sciences where data is often large and multifaceted. AIC (Akaike Information Criterion) model selection is a valuable tool for this purpose, providing a systematic approach to refine models by balancing simplicity and predictive performance.

This tutorial will guide you through the principles and application of AIC-based model selection for linear models. By the end, you will understand why and when to perform AIC model selection, learn to interpret key evaluation metrics, and gain hands-on experience with drop1() and step() functions in R. These methods will be applied to real-world problems in environmental sciences, equipping you with practical skills for addressing challenges in big data analysis.



---

## Prerequisites
{: #Prerequisites}

This tutorial is designed for novice and intermediate learners in statistical analysis who enjoy understadnign the theory behind R fucntions. If this is not your preference, you might find this tutorial less suited to your needs—consider exploring other resources, such as , which serves as a precursor to this guide.  

Depending on your level of expertise, you can tailor your experience by focusing on the sections most relevant to you. Beginners may want to concentrate on just applying methods like `step` and `drop1`. However, to get the most out of this tutorial, it’s helpful to have a foundational understanding of the typical evalutaion metrics used with linear models such as $R^2$ and $RSE$

While we will be using the programming language **R** throughout this tutorial, the principles and techniques covered are applicable across various programming environments. To fully engage with the coding examples provided, you should have a basic understanding of:  
- **Linear models** using the `lm()` function  
- Interpreting the **summary output** of linear models  


If you’re new to linar models in R or need a refresher, the Coding Club website offers excellent resources to get you up to speed:  
- [From Distruvutions to Linear Modles](https://ourcodingclub.github.io/tutorials/modelling/)  
- [Introduction to Model Design](https://ourcodingclub.github.io/tutorials/model-design/)


This tutorial builds on these foundational skills, focusing on the process of AIC model selection for linear models with categorical and numerical variables.

---

## Data and Materials
{: #DataMat}

You can find all the data that you require for completing this tutorial on this [GitHub repository](). We encourage you to download the data to your computer and work through the examples along the tutorial as this reinforces your understanding of the concepts taught in the tutorial. In this tutorial we will work with data from the `faraway` and `palmerspenguin` package, both of these are package in R containing different datasets. 

Now we are ready to dive into the this tutorial!

---

# 2. Akaike Information Criterion (AIC)  
{: #AIC}  

Up until now the main evaluation metric on how to make model-based descionshas been the **p-value** and although this is a powerful metric in real-world scenarios it has limitations. In large datasets, p-values often identify statistically significant variables that have negligible practical relevance, leading to unnecessarily complex models. Additionally, p-values do not measure a variable’s importance or effect size and can become unreliable in the presence of multicollinearity, where overlapping effects between predictors obscure their individual contributions. Focusing solely on p-values risks overfitting, reducing a model's generalizability and predictive accuracy.  

To address these limitations, we must consider broader evaluation metrics that assess both the accuracy and complexity of a model. In this tutorial we will focus on the **Akaike Information Criterion (AIC)** and how it can be used in model selection. 

### So what is AIC?

The **AIC** is a widely used metric for evaluating model quality by balancing goodness of fit with model complexity. It helps identify models that explain the data effectively while avoiding unnecessary complexity. A **lower AIC value** indicates a model that achieves a better trade-off between accuracy and simplicity.  

<center><img src="{{ site.baseurl }}/figures/AIC_Chart.png" alt="Img" style="width: 100%; height: auto;"></center>

When comparing models, the one with the smallest AIC is typically preferred, as it represents the most efficient explanation of the data with minimal risk of overfitting. However, it is crucial to remember that AIC values are relative and can only be compared across models fitted to the same dataset.  Furthermore, while AIC favors simpler models, it should not be used in isolation. It complements other evaluation metrics, offering a holistic approach to model selection by ensuring the chosen model is both interpretable and generalisable.

For those of you who are intersted the formula is as follows:

<center><img src="{{ site.baseurl }}/figures/AIC_Formula.jpeg" alt="Img" style="width: 100%; height: auto;"></center>


---
So now that we know what AIC is, lets have a look at how we can apply it when performing model selection!

---
# 3 AIC Stepwise Model Selection
{: #selection}

In this tutorial we will focus on **backwards stewpwise AIC model selection**, which is a systematic approach to refine a statistical model by removing explanatory variables from a large complex model based on the AIC. Stay tuned for next weeks tutorial on **forward stewpwise AIC model selection**. The goal is to strike a balance between a model that fits the data well and one that is not overly complex, thus the accuracy metric we focus on is AIC!


### When would we use AIC model selection?

We use model selection when we are modeling a large data set that has multiple potential explanatory variables. For example, a model on climate data might include variables such as temperature, precipitation, wind speed, solar radiation and many more! By selecting the most relevant variables, we can simplify the model while maintaining its predictive accuracy.

Our goal throughout this section is to **minimize the AIC**, as this reflects a model that explains the data well without being overly complex.

It is important to note that we only drop *one variable at a time* when perfoming AIC stepwise model selection. This is so we can isolate an explanatory variable impact on the model’s performance, ensuring clarity in how each variable contributes to explaining the response variable. The `drop1` and `step` function both illustrate this, showing the effect of dropping each variable while keeping others in the model. For example, if AIC decreases when dropping `sex` and it also decreased when we drop `size`, we cannot conclude both should be removed because the model retains `size` when assessing `sex`, and vice versa. Therefore, from this alone we do not know the affect of dropping both variables and further analysis must be done to decide if both variables should be dropped. This approach prevents misleading conclusions, preserves model structure, and ensures fair, accurate evaluations.

To begin with lets have a look at how we can do AIC model selection using the `drop1` function.

---
## 3.1 Drop 1
{: #drop1}

The `drop1` function in R is used during model selection to evaluate the impact of removing individual variables from a model. It one of the most commonly used function in stepwise model selection and it works by comparing the AIC values of models with and without each variable. We remeber from section 3 a **lower AIC** indicates a better model, as it suggests a better balance between fit and complexity and a **high Sum of Sq** indicates the predictor we are looking at significantly helps explain the response variable.

**What `drop1` Does**  
The `drop1` function evaluates what happens to the AIC if each variable in the model is removed one at a time. For each variable:
   - It calculates the AIC of the model without that variable.
   - It provides a table showing the AIC for all possible one-variable-removal models.

**The `drop1` Table**
| **Column**                     | **What It Represents**                                                                                                                                                                      | **Why It's Important**                                                                                                                                                     | **How Each Column Helps Track Impact**                                                                                                                                   |
|--------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Df (Degrees of Freedom)**    | The number of parameters associated with each explanatory variable (i.e., the number of levels the explanatory variable has). It is important to remember that when we have categorical variables, they include a baseline in the intercept. For example, if a categorical variable has 3 levels, the first level is part of the baseline, leaving 2 levels (and thus 2 degrees of freedom). | Indicates the complexity of the model. Predictors with higher Df contribute more parameters, increasing model complexity. Removing a predictor reduces the model's Df.     | Tracks how the model's complexity changes when a predictor is removed, helping assess if simplifying the model is justifiable.                                             |
| **Sum of Squares (Sum of Sq)** | The variation in the response variable explained by each explanatory variable.                                                                                                              | Shows each explanatory variable’s contribution to explaining variance in the response. Larger values indicate stronger explanatory power.                                  | Highlights the explanatory variables with substantial impact, making them candidates for retention in the model (i.e., we don’t want to drop them!).                      |
| **Residual Sum of Squares (RSS)** | The amount of unexplained variance (errors) after the model is fitted without the explanatory variable.                                                                                     | A lower RSS means the model fits the data better by explaining more variance. High RSS indicates a worse fit after removing an explanatory variable (i.e., we don’t drop it!). | Tracks how much variance is left unexplained if an explanatory variable is removed, revealing its importance in reducing errors in the model.                              |
| **AIC**                        | The model's AIC after the explanatory variable has been removed.                                                                                                                             | A lower AIC indicates a model that better balances accuracy and simplicity.                                                                                               | Helps identify explanatory variables that improve the model’s AIC when removed, making them candidates for removal if the AIC improves.                                   |

How to Interpret the Results**  
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

<center><img src="{{ site.baseurl }}/figures/drop1(africa_lm).png" alt="Img" style="width: 100%; height: auto;"></center>



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

### So What Are Our Key Insights?

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

### So What Are Our Next Steps
Based on the `drop1` results, the following steps are recommended:  
- Retain the interaction term `oligarchy:parties` and `as.factor(pollib`, as they contribute significantly to the model.  
- Consider removing `size` and `numregim` to simplify the model while improving AIC.  
- Reassess `popn` and `numelec` to determine their relevance in the context of overall model performance.  

---

Tada now we know that we can use `drop1` function in R and understand its ouput for both interaction and no interaction models for model selection! 

Since we only remove one term at a time (focusing on the term whose removal leads to the biggest reduction in AIC), applying the `drop1` function repeatedly is necessary until no further improvements in AIC can be made. However, this process can become tedious and inefficient when dealing with large models containing many variables. That’s where the `step` function comes to the rescue!


---
## 3.2 Step
{: #step}  

The `step` function streamlines the process by automating the stepwise approach. It iteratively adds or removes variables to optimize the model based on AIC. Essentially, the `step` function handles the repeated application of `drop1` for us, outputting the final model where removing any explanatory variable would increase the AIC.

**How the `step` Function Works**

The `step` function in R automates stepwise model selection by evaluating the AIC for all deletions of predictors at each step. Here's how it works:
1. The function starts with our initial model with lots of explanatory variables in it.
2. It iteratively evaluates potential models by removing each variable and calculating the AIC, selecting the model with the **lowest AIC** to carry forward.
3. It repeats this process untill removing variables reduces the AIC, i.e we have the 'best' model accoridng to AIC>

**How to Interpret the Results**  

For each iteration the `step` function creates a summary table which shows the details of each model, the models are listed from **lowest to highest** AIC. The **<none> Row** shows the current model’s performance (AIC, RSS, etc.) before any changes (i.e., before any predictor is removed), it serves as a reference point for comparing the impact of removing predictors and helps assess how each variable removal affects the model.       

Each column tells us something different for the model we are looking at:
| **Column**                     | **What It Represents**                                                                                                                                   | **Why It's Important**                                                                                                                                                           | **How Each Column Helps Track Impact**                                                                                                                                               |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Df (Degrees of Freedom)**     | The number of parameters (or pieces of information) associated with each predictor minus 1.                                                                    | Indicates the complexity of the model. A predictor with higher Df typically contributes more parameters to the model. The removal of a predictor reduces the model's Df.           | Shows how the number of parameters changes when a predictor is added or removed.                                                                                                       |
| **Sum of Squares (Sum of Sq)**  | The amount of variation explained by each predictor in the model.                                                                                     | Shows the contribution of each predictor to explaining the variance in the dependent variable. Larger values indicate greater contribution.                                       | Indicates how much variation is explained by a predictor. A larger value means the predictor contributes more to explaining the response variable.                                  |
| **Residual Sum of Squares (RSS)** | The amount of unexplained variance (errors) after fitting the model.                                                                                 | A lower RSS indicates a better-fitting model because the model explains more of the variance in the data. The goal is to minimize RSS.                                           | Reveals how much unexplained variance remains after fitting the model. A lower RSS suggests better model fit.                                                                         |
| **Akaike Information Criterion (AIC)** | A measure used for model selection that balances model fit and complexity (number of parameters).                                                   | A lower AIC indicates a better model that balances fit and complexity. The `step()` function selects models based on the lowest AIC.                                             | The primary measure for model selection. The goal is to minimize AIC by selecting the model with the best balance between complexity and fit.                                        |


 **Final Model**:
   - After the iterations, the final model is displayed, which has the **lowest AIC** and is considered the best model based on the AIC criterion.
   - After the function makes a selection, the coefficients of the final model show the impact of each predictor on the outcome variable.

**Key Points for Interpretation**  
- *Lower AIC is better:** The goal is to minimize the AIC by selecting variables that improve the balance between fit and complexity.
- At each iteration we only remove **one** variable to maintain control over model complexity, accurately assess each predictor’s impact, and prevent overfitting. This iterative approach ensures that the model is gradually simplified while preserving its predictive power. By removing variables one by one, the process allows for careful evaluation of how each predictor affects the model's performance (AIC and fit), avoids drastic changes that could harm the model, and ensures computational efficiency.
- The process stops when *no variable removal* reduces the AIC further.  
- *Removed variables:** Variables whose exclusion lowers the AIC were likely not contributing significantly to the model. 


 **Why Use `step`?**  
The `step` function is particularly useful when dealing with a large number of predictors, as it automates the model selection process. It ensures a systematic evaluation of the impact of each variable, saving time and effort compared to manually using `drop1`. However, caution is needed to avoid overfitting or underfitting, as the process is driven solely by AIC without considering domain knowledge or practical significance.  
 
Lets have a look at some examples with and without interaction terms! Lets continue with the `africa` data from the faraway package about the miltary coups and politics in sub-Saharan Africa. 
 
### Example Without an Interaction Term

We first look at our linear model without interaction terms:

```r
#define linear model
africa_lm <- lm(miltcoup ~ oligarchy + as.factor(pollib) + parties + popn + size
+ numelec + numregim, africa_data)
```

This is a huge model with lots of predictors. How can we *effeciently* make sure that all these predictors are necessary and we are not overfitting? The `step` fucntion!

Lets apply the `step` function and see what happens:

```r
#apply step()
step(africa_lm)
```

We get the following output:

<center><img src="{{ site.baseurl }}/figures/step(africa_lm).png" alt="Img" style="width: 100%; height: auto;"></center>

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


<center><img src="{{ site.baseurl }}/figures/step(africa_interact_lm).png" alt="Img" style="width: 100%; height: auto;"></center>

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

---

# 5. Summary

----

# 6. Challenge


In this example, we use the penguins_clean dataset, which is a cleaned version of the `penguins` data from the `palmerpenguins package`. Compaare the symmarises has it improved?

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

]

# 4. Summary 



These methods can be used together or separately depending on the stage of model selection:


Stepwise selection might be used first to identify a good baseline model.
Drop1 and 1-way ANOVA can then be applied to further refine the model.
2-way ANOVA provides a final check on whether removing interaction terms leads to a significant loss in model fit.
