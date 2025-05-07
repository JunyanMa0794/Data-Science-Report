# 6.3.2 Comparative Analysis of Model Performance

# Define a unified evaluation function
evaluate_model <- function(predictions, true_labels, model_name) {
  # Create a result data frame
  result_df <- data.frame(
    truth = factor(true_labels, levels = c("B", "M")),
    prediction = factor(predictions, levels = c("B", "M"))
  )
  
  acc <- as.numeric(accuracy(result_df, truth, prediction)[[".estimate"]])
  precision_macro <- as.numeric(precision(result_df, truth, prediction, 
                                          estimator = "macro")[[".estimate"]])
  recall_macro <- as.numeric(recall(result_df, truth, prediction, 
                                    estimator = "macro")[[".estimate"]])
  f1_macro <- as.numeric(f_meas(result_df, truth, prediction, 
                                estimator = "macro")[[".estimate"]])
  
  return(data.frame(
    Model = model_name,
    Accuracy = round(acc, 4),
    Macro_Precision = round(precision_macro, 4),
    Macro_Recall = round(recall_macro, 4),
    Macro_F1 = round(f1_macro, 4)
  ))
}

# Make predictions on the test set and evaluate
svm_pred <- predict(svm_model, newdata = test_data)
dt_pred <- predict(dt_model, newdata = test_data)
rf_pred <- predict(rf_model, newdata = test_data)
ada_pred <- predict(ada_model, newdata = test_data)

# Aggregate evaluation results
results <- bind_rows(
  evaluate_model(svm_pred, test_data$diagnosis, "SVM"),
  evaluate_model(dt_pred, test_data$diagnosis, "Decision Tree"),
  evaluate_model(rf_pred, test_data$diagnosis, "Random Forest"),
  evaluate_model(ada_pred, test_data$diagnosis, "Adaboost")
)

# Output the final model performance table
print(results)    