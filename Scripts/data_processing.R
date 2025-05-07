# 3.1 Data Cleaning

# Load necessary packages
library(tidyverse)
library(moments)
library(corrplot)
library(ggplot2)
library(ggfortify)
library(ggcorrplot)

# Read the raw dataset
data_raw <- read.csv("Cancer_Data_Raw.csv")

# Remove columns that are entirely NA (common example: "X" column)
data_processed <- data_raw[, colSums(is.na(data_raw)) < nrow(data_raw)]

# Display dataset structure
str(data_processed)

# Check for missing values (total and per column)
colSums(is.na(data_processed))

# Check for duplicate rows
sum(duplicated(data_processed))

# Remove columns with no analytical significance, such as "id"
data_processed <- data_processed[, !names(data_processed) %in% c("id")]

# Convert "diagnosis" column to factor (B = Benign, M = Malignant)
data_processed$diagnosis <- factor(data_processed$diagnosis, levels = c("B", "M"))

# Save the cleaned dataset
write.csv(data_processed, "Cancer_Data_Processed.csv", row.names = FALSE)


# 3.2 Descriptive Statistical Analysis

# Display summary statistics
summary(data_processed)

# Calculate mean and standard deviation for each feature grouped by diagnosis
data_processed %>%
  group_by(diagnosis) %>%
  summarize(across(where(is.numeric), list(mean = mean, sd = sd)))

# Count of benign and malignant cases
table(data_processed$diagnosis)

# Compute skewness and kurtosis for each numeric feature
skewness_values <- sapply(data_processed[, sapply(data_processed, is.numeric)],
                          skewness)
kurtosis_values <- sapply(data_processed[, sapply(data_processed, is.numeric)],
                          kurtosis)

data.frame(Feature = names(skewness_values), Skewness = skewness_values, 
           Kurtosis = kurtosis_values)


### 3.3 Visual Analysis

# Histogram: Tumor radius distribution by diagnosis
ggplot(data_processed, aes(x = radius_mean, fill = diagnosis)) +
  geom_histogram(bins = 30, alpha = 0.6, position = "identity") +
  labs(title = "Tumor Radius Distribution", x = "Mean Radius", y = "Count") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Boxplot: Comparison of concavity between benign and malignant tumors
ggplot(data_processed, aes(x = diagnosis, y = concavity_mean, fill = diagnosis)) +
  geom_boxplot(alpha = 0.6) +
  labs(title = "Comparison of Tumor Concavity", 
       x = "Diagnosis", y = "Mean Concavity") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  


# Correlation heatmap
cor_matrix <- cor(data_processed[, sapply(data_processed, is.numeric)])
corrplot(cor_matrix, method = "color", tl.cex = 0.5, tl.col = "black")

# Principal Component Analysis (PCA)
pca_res <- prcomp(data_processed[, sapply(data_processed, is.numeric)], scale. = TRUE)

# PCA visualization
autoplot(pca_res, data = data_processed, colour = 'diagnosis') +
  labs(title = "Principal Component Analysis (PCA)", x = "PC1", y = "PC2") +
  theme(plot.title = element_text(hjust = 0.5))  

