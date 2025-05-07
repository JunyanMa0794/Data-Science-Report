# 6.1 Model Training Process

library(caret)
library(e1071)      # SVM
library(rpart)      # Decision Tree
library(randomForest)
library(gbm)        # Adaboost
library(yardstick)  # For precision/recall/F1
library(dplyr)

# Set the random seed
set.seed(123)

# Split the dataset into training and test sets
train_index <- createDataPartition(final_data$diagnosis, p = 0.8, list = FALSE)
train_data <- final_data[train_index, ]
test_data <- final_data[-train_index, ]

# Train the SVM model
svm_model <- train(
  diagnosis ~ .,
  data = train_data,
  method = "svmRadial",
  trControl = trainControl(method = "cv", number = 5),
  preProcess = c("center", "scale")
)

# Decision Tree model
dt_model <- train(
  diagnosis ~ .,
  data = train_data,
  method = "rpart",
  trControl = trainControl(method = "cv", number = 5),
  preProcess = c("center", "scale")
)

# Random Forest model
rf_model <- train(
  diagnosis ~ .,
  data = train_data,
  method = "rf",
  trControl = trainControl(method = "cv", number = 5),
  preProcess = c("center", "scale")
)

# Adaboost (based on Gradient Boosting)
ada_model <- train(
  diagnosis ~ .,
  data = train_data,
  method = "gbm",
  trControl = trainControl(method = "cv", number = 5),
  preProcess = c("center", "scale"),
  verbose = FALSE
)


# 6.2 Feature importance analysis

# Decision tree feature importance analysis
dt_importance <- dt_model$finalModel$variable.importance
dt_importance_df <- data.frame(Feature = names(dt_importance), 
                               Importance = dt_importance)
# Sort by importance
dt_importance_df <- dt_importance_df[order(-dt_importance_df$Importance), ]

# Plot the decision tree feature importance graph
ggplot(dt_importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "#FF9999") +
  labs(title = "Decision Tree Feature Importance", 
       x = "Feature", y = "Importance") +
  coord_flip() +
  theme(plot.title = element_text(hjust = 0.5))  

# Random forest feature importance analysis
rf_importance <- randomForest::importance(rf_model$finalModel)
rf_importance_df <- data.frame(Feature = rownames(rf_importance), 
                               Importance = rf_importance[, 'MeanDecreaseGini'])
# Sort by importance
rf_importance_df <- rf_importance_df[order(-rf_importance_df$Importance), ]

# Plot the random forest feature importance graph
ggplot(rf_importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "#66CCCC") +
  labs(title = "Random Forest Feature Importance", 
       x = "Feature", y = "Mean Decrease Gini") +
  coord_flip() +
  theme(plot.title = element_text(hjust = 0.5))

