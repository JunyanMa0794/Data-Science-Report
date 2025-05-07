# 4.1 Feature Scaling

# Define Min-Max Scaling function
min_max_scaling <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# Apply normalization to all numeric columns except "diagnosis"
data_normalized <- data_processed %>%
  mutate(across(where(is.numeric), min_max_scaling))

# Save the normalized dataset
write.csv(data_normalized, "Cancer_Data_Normalized.csv", row.names = FALSE)

# Display summary of normalized data
summary(data_normalized)


# 4.2 Feature Selection

# Convert diagnosis to numeric (B = 0, M = 1) for further analysis
data_temp <- data_normalized
data_temp$diagnosis_numeric <- as.numeric(data_temp$diagnosis) - 1

# 1. Variance Filtering (excluding the diagnosis column for calculation)
num_data <- data_temp %>% select(where(is.numeric), -diagnosis_numeric)
variance <- apply(num_data, 2, var)

# Set threshold to filter out low-variance features (threshold set to 0.01)
low_variance_features <- names(variance[variance < 0.01])
data_filtered <- data_temp %>% select(-all_of(low_variance_features))

# 2. Correlation Analysis (considering only correlation with diagnosis_numeric)
cor_matrix <- cor(data_filtered %>% select(where(is.numeric)))
cor_target <- cor_matrix["diagnosis_numeric", ]
cor_target <- cor_target[!names(cor_target) %in% c("diagnosis_numeric")]

# Select the top 10 features most correlated with diagnosis
top10_features <- sort(abs(cor_target), decreasing = TRUE)[1:10]
selected_features <- names(top10_features)

# Retain these features for modeling
final_data <- data_filtered %>% select(all_of(selected_features), diagnosis)

# Save the final dataset
write.csv(final_data, "Cancer_Data_Final.csv", row.names = FALSE)

# View the structure of the final dataset
str(final_data)

# Draw a correlation bar chart
cor_plot_data <- data.frame(
  Feature = names(top10_features),
  Correlation = cor_target[names(top10_features)],
  Absolute = abs(cor_target[names(top10_features)])
) %>% 
  arrange(desc(Absolute))

ggplot(cor_plot_data, aes(x = reorder(Feature, Absolute), y = Absolute, 
                          fill = Correlation)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient2(low = "#FF9999", mid = "white", high = "#66CCCC", 
                       midpoint = 0, limits = c(-1, 1)) +
  labs(title = "Top 10 Features Correlated with Diagnosis",
       x = "Features",
       y = "Absolute Correlation Coefficient",
       fill = "Correlation") +
  coord_flip() +  
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        axis.text.y = element_text(size = 10),
        legend.position = "right")

