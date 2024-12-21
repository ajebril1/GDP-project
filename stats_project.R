#install.packages("tidyverse")
#install.packages("car")
#install.packages("caret")
# loading needed libraries
library(tidyverse)
library(caret)
library(car)

# loading the dataset
data <- read.csv("/Users/ahmadjebril/Downloads/Global Economy Indicators.csv")

# looking at the first few rows of the dataset
head(data)

# understanding the structure of the dataset 
str(data)

# Exploratory Data Analysis (EDA)
# summary statistics
summary(data)

# checking column names
colnames(data)

# Checking for missing values
colSums(is.na(data))

# Calculating Net Exports
data$Net_Exports <- data$Exports.of.goods.and.services - data$Imports.of.goods.and.services

# correlation matrix calculation
correlation_matrix <- cor(data[, c("Gross.Domestic.Product..GDP.", 
                                   "Final.consumption.expenditure", 
                                   "Gross.capital.formation", 
                                   "Net_Exports", 
                                   "General.government.final.consumption.expenditure")], 
                          use = "complete.obs")

# Displaying the correlation matrix
print(correlation_matrix)

# Cleaning the data
# imputing using the mean
data <- data %>%
  mutate(across(c("Exports.of.goods.and.services", 
                  "General.government.final.consumption.expenditure", 
                  "Gross.capital.formation", 
                  "Gross.fixed.capital.formation..including.Acquisitions.less.disposals.of.valuables.",
                  "Household.consumption.expenditure..including.Non.profit.institutions.serving.households.", 
                  "Imports.of.goods.and.services", 
                  "Manufacturing..ISIC.D.", 
                  "X.Transport..storage.and.communication..ISIC.I..",  # Corrected name with extra dots
                  "X.Wholesale..retail.trade..restaurants.and.hotels..ISIC.G.H.."), 
                ~ifelse(is.na(.), mean(., na.rm = TRUE), .)))

# removing columns
data <- data %>% select(-c("Changes.in.inventories", "X.Agriculture..hunting..forestry..fishing..ISIC.A.B.."))

# checking for outliers
# creating boxplot for GDP
boxplot(data$Gross.Domestic.Product..GDP., main = "GDP Growth", ylab = "GDP Growth")

# Calculate IQR for GDP growth
gdp_iqr <- IQR(data$Gross.Domestic.Product..GDP., na.rm = TRUE)

# Calculate the lower and upper bounds for outliers
Q1 <- quantile(data$Gross.Domestic.Product..GDP., 0.25, na.rm = TRUE)
Q3 <- quantile(data$Gross.Domestic.Product..GDP., 0.75, na.rm = TRUE)

lower_bound <- Q1 - 1.5 * gdp_iqr
upper_bound <- Q3 + 1.5 * gdp_iqr

# Identify outliers
outliers <- data$Gross.Domestic.Product..GDP.[data$Gross.Domestic.Product..GDP. < lower_bound | data$Gross.Domestic.Product..GDP. > upper_bound]
print(outliers)


# creating boxplot for consumption expenditure
boxplot(data$Final.consumption.expenditure, main = "Consumption Expenditure", ylab = "Consumption")

# creating a boxplot for investment
boxplot(data$Gross.capital.formation, main = "Gross Capital Formation", ylab = "Investment")

# feature scaling
data_scaled <- data %>%
  mutate(across(c("Final.consumption.expenditure", 
                  "Gross.capital.formation", 
                  "Net_Exports", 
                  "General.government.final.consumption.expenditure"), 
                scale))

# Fitting the multiple linear regression model
model <- lm(Gross.Domestic.Product..GDP. ~ Final.consumption.expenditure + 
              Gross.capital.formation + 
              Net_Exports + 
              General.government.final.consumption.expenditure, 
            data = data)

# Summary of the model
summary(model)

# Calcualting VIF
vif(model)

# Setting seed for reproducibility
set.seed(123)

# Creating an index for the training set (80%) and testing set (20%)
trainIndex <- createDataPartition(data$Gross.Domestic.Product..GDP., p = 0.8, list = FALSE)

# Creating the training and testing datasets
train_data <- data[trainIndex, ]
test_data <- data[-trainIndex, ]


# Creating a new variable combining consumption expenditure and government spending
data$Total_consumption <- data$Final.consumption.expenditure + 
  data$General.government.final.consumption.expenditure

# Fit the model on the training data
model_train <- lm(Gross.Domestic.Product..GDP. ~ Total_consumption + 
                    Gross.capital.formation + Net_Exports, 
                  data = train_data)

# Summary of the model on the training data
summary(model_train)

# Predicting GDP values on the test data
predictions <- predict(model_train, test_data)

# Check for missing values in the target variable
sum(is.na(test_data$Gross.Domestic.Product..GDP.))

# checking the length to see if they match
length(predictions)
nrow(test_data)

# ensuring both are numeric
class(predictions)
class(test_data$Gross.Domestic.Product..GDP.)

# Removing NA values from both predictions and actual values
valid_indices <- !is.na(predictions) & !is.na(test_data$Gross.Domestic.Product..GDP.)

# Calculating RMSE with valid data
rmse <- sqrt(mean((test_data$Gross.Domestic.Product..GDP.[valid_indices] - predictions[valid_indices])^2))
print(paste("RMSE:", rmse))


# Calculating VIF for the revised model
vif(model_train)

# creating a residual plot
plot(model_train$residuals)

# normality of residuals 
hist(model_train$residuals)

#FINAL MODEL USED FOR REPORT
# Selecting only the relevant columns
data_subset <- data %>%
  select(Gross.Domestic.Product..GDP., Total_consumption, 
         Gross.capital.formation, Net_Exports)

# Summary statistics for relevant columns
summary(data_subset)

# Correlation matrix for relevant columns
correlation_matrix <- cor(data_subset, use = "complete.obs")
print(correlation_matrix)

# Scatterplots
plot(data_subset$Gross.Domestic.Product..GDP., 
     main = "GDP vs Total Consumption",
     xlab = "Total Consumption", ylab = "GDP")
plot(data_subset$Gross.capital.formation, data_subset$Gross.Domestic.Product..GDP., 
     main = "GDP vs Investment", xlab = "Investment", ylab = "GDP")
plot(data_subset$Net_Exports, data_subset$Gross.Domestic.Product..GDP., 
     main = "GDP vs Net Exports", xlab = "Net Exports", ylab = "GDP")

# Adding Total_consumption to the training data and testing data
train_data$Total_consumption <- train_data$Final.consumption.expenditure + 
  train_data$General.government.final.consumption.expenditure

test_data$Total_consumption <- test_data$Final.consumption.expenditure + 
  test_data$General.government.final.consumption.expenditure

# Fitting the regression model
final_model <- lm(Gross.Domestic.Product..GDP. ~ Total_consumption + 
              Gross.capital.formation + Net_Exports, 
            data = train_data)

# Summary of the model
summary(final_model)

# Predicting GDP values on the test data
predictions <- predict(final_model, test_data)

# Checking for NA values in predictions
sum(is.na(predictions))

# Checking for NA values in the actual GDP values
sum(is.na(test_data$Gross.Domestic.Product..GDP.))


# Calculating RMSE excluding NA values
rmse <- sqrt(mean((test_data$Gross.Domestic.Product..GDP.[!is.na(predictions)] - 
                     predictions[!is.na(predictions)])^2))
print(paste("RMSE:", rmse))

# Residuals plot
plot(final_model$residuals, main = "Residual Plot", ylab = "Residuals", xlab = "Fitted Values")
abline(h = 0, col = "red")

# VIF calculation
vif(final_model)

