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
2. [**Evaluation Metrics**](#eval)
  - [Coefficient](#Coeff)
  - [$R^2$](#R)
  - [Residual Standard Error (RSE)](#RSE)
  - [F-Statistic](#f)
  - [AIC](#AIC)
  - [RSS and Sum of Sq](#AIC)
3. [**Stepwise Model Selection**](#selection)
  - [Drop1](#drop)
  - [Step](#step)
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

Now we are ready to dive into the world of model selection!

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
2. [**Evaluation Metrics**](#eval)
  - [Coefficient](#Coeff)
  - [$R^2$](#R)
  - [Residual Standard Error (RSE)](#RSE)
  - [F-Statistic](#f)
  - [AIC](#AIC)
  - [RSS and Sum of Sq](#AIC)
3. [**Stepwise Model Selection**](#step)
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

Now we are ready to dive into the world of model selection!

---
Here’s an improved and polished version of your section on evaluation metrics, incorporating feedback and revisions for clarity, tone, consistency, and flow:

---

# 2. Evaluation Metrics  
{: #eval}  

Before diving into the world of AIC model selection, let’s first explore some key evaluation metrics for assessing model performance. While the **p-value** is a familiar metric, it has significant limitations, particularly in real-world scenarios. In large datasets, p-values often identify statistically significant variables that have negligible practical relevance, leading to unnecessarily complex models. Additionally, p-values do not measure a variable’s importance or effect size and can become unreliable in the presence of multicollinearity, where overlapping effects between predictors obscure their individual contributions. Focusing solely on p-values risks overfitting, reducing a model's generalizability and predictive accuracy.  

To address these limitations, we must consider broader evaluation metrics that assess both the accuracy and complexity of a model. This tutorial will discuss key metrics, including **$R^2$**, **Adjusted $R^2$**, **Residual Standard Error (RSE)**, **Residual Sum of Squares (RSS)**, and the **Akaike Information Criterion (AIC)**. These measures provide a comprehensive perspective on model performance, helping to select models that balance simplicity and predictive power.  

---

## 2.1 $R^2$ and Adjusted $R^2$  
{: #R2}  

The **$R^2$ value** measures the proportion of variability in the dependent variable explained by the model's predictors. Values range from 0 to 1, with a higher $R^2$ indicating a stronger fit. However, $R^2$ does not account for the number of predictors in the model, meaning it will always increase as predictors are added, regardless of their relevance.  

To address this, **Adjusted $R^2$** penalizes the addition of predictors that do not significantly improve the model's explanatory power. It provides a more reliable metric for comparing models with different numbers of predictors. For example, an Adjusted $R^2$ value that remains stable or increases when predictors are added indicates that these predictors meaningfully contribute to the model.  

While both metrics offer insight into overall model performance, they must be interpreted cautiously. A high $R^2$ or Adjusted $R^2$ does not guarantee a good model; overfitting or irrelevant predictors can inflate these values.  

---

## 2.2 Residual Standard Error (RSE)  
{: #RSE}  

The **Residual Standard Error (RSE)** measures the average deviation of observed values from their predicted values. It represents the standard deviation of residuals and is expressed in the same units as the response variable, making it easy to interpret. Smaller RSE values indicate better predictive accuracy, while larger values suggest a weaker fit.  

For instance, in R, outputs like `summary()` report the RSE to help evaluate model fit. While a lower RSE is generally desirable, it must be considered alongside metrics like $R^2$ and AIC to ensure the model balances accuracy and complexity without overfitting.  

**Complementarity of $R^2$ and RSE:** While $R^2$ quantifies explained variability, RSE focuses on prediction error. Together, they provide a more holistic view of model performance.  

---

## 2.3 Akaike Information Criterion (AIC)  
{: #AIC}  

The **Akaike Information Criterion (AIC)** evaluates model quality by balancing goodness of fit with model complexity. A lower AIC value indicates a model that achieves an optimal trade-off between accuracy and simplicity.  

In R, functions like `step()` use AIC to guide model selection by iteratively adding or removing predictors. It is important to note that AIC values are relative and should only be compared across models fitted to the same dataset. While AIC prioritizes parsimony, it should complement, rather than replace, other evaluation metrics.  

---

## 2.4 Residual Sum of Squares (RSS) & Sum of Squares (Sum of Sq)  
{: #RSS}  

**Residual Sum of Squares (RSS)** quantifies the variation in the dependent variable that remains unexplained by the model. It is calculated as:  

$$RSS = \sum_{i=1}^n (y_i - \hat{y}_i)^2$$  

A smaller RSS indicates better model fit, with predictions closer to the actual data.  

The **Sum of Squares (Sum of Sq)** measures total variability in the dependent variable, serving as a baseline for comparison. It is calculated as:  

$$\text{Sum of Sq} = \sum_{i=1}^n (y_i - \bar{y})^2$$  

Where $\bar{y}$ is the mean of the observed values. A large Sum of Sq for a predictor indicates its importance in explaining the response variable, while a small value suggests limited relevance.  

---

By combining these metrics, we gain a comprehensive understanding of model performance, ensuring that selected models are both accurate and interpretable. Now, let’s move on to exploring R functions and their outputs for practical applications.  

---
# 3 Step-Wise Model Selection
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
## 3.1 Drop 1
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

----
# 3 Step-Wise Model Selection
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
## 3.1 Drop 1
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
