# Global Economy Indicators Analysis

## Project Overview

This project aims to analyze global economic indicators and understand the relationships between different variables, such as Gross Domestic Product (GDP), consumption expenditure, capital formation, and net exports. The goal is to build a multiple linear regression model to predict GDP based on key economic factors. The project involves steps like data cleaning, exploratory data analysis (EDA), feature scaling, model building, and evaluation.

## Steps Involved

### 1. **Data Loading & Preprocessing**
   - Loaded the dataset containing various global economy indicators.
   - Performed initial checks for missing values and cleaned the data by imputing missing values using the mean.
   - Removed irrelevant columns and performed outlier detection using boxplots and IQR calculations.

### 2. **Exploratory Data Analysis (EDA)**
   - Generated summary statistics and visualized distributions and relationships between key variables.
   - Calculated correlations between the predictors (e.g., GDP, consumption expenditure, capital formation, net exports) to identify significant relationships.
   - Visualized the data using boxplots to understand outliers in important variables like GDP, consumption expenditure, and capital formation.

### 3. **Feature Engineering**
   - Created new features like "Net Exports" (Exports minus Imports) and "Total Consumption" (Consumption Expenditure plus Government Spending).
   - Scaled certain features to standardize their values and ensure proper model fitting.

### 4. **Model Building**
   - Built a multiple linear regression model to predict GDP based on consumption expenditure, capital formation, net exports, and government expenditure.
   - Divided the data into training (80%) and testing (20%) sets for model training and evaluation.
   - Tuned the model and evaluated its performance using various metrics, including RMSE (Root Mean Squared Error) and VIF (Variance Inflation Factor).

### 5. **Model Evaluation**
   - Checked for multicollinearity using VIF to ensure no predictor had high correlation with others.
   - Evaluated the model on the test data, predicting GDP values and comparing them with the actual values.
   - Visualized the residuals and checked for any patterns to assess model fit and normality of residuals.

### 6. **Final Model & Predictions**
   - After evaluating various models, a final model was selected that included Total Consumption, Gross Capital Formation, and Net Exports as the key predictors of GDP.
   - The final model was used to predict GDP for the test data, and the performance was measured using RMSE.

## Key Findings
   - There is a significant relationship between GDP and variables like Total Consumption, Capital Formation, and Net Exports.
   - The final model shows good prediction accuracy, with RMSE providing a measure of error in GDP predictions.
   - Multicollinearity was checked using VIF, ensuring that the predictors were not highly correlated.

## Tools & Libraries
   - **R**: The primary programming language for analysis and modeling.
   - **tidyverse**: For data manipulation and visualization.
   - **caret**: For creating training and testing sets and model evaluation.
   - **car**: For calculating Variance Inflation Factor (VIF) to check multicollinearity.

