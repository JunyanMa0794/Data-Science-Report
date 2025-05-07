# Data-Science-Report

## A reproducible data analysis report -- Tumor Classification with Machine Learning

### Project Overview
This research compares multiple machine learning models for classifying tumor malignancy using the Wisconsin Breast Cancer dataset. The study aims to identify the most accurate model to support clinical diagnosis.

### Dataset

• Source: Wisconsin Breast Cancer (Diagnostic) dataset from UCI Machine Learning Repository and Kaggle

• Size: 569 patient samples

• Features: 30 numerical diagnostic measurements

• Target: Binary classification (Malignant="M", Benign="B")


### Implementation
#### Data Preprocessing
1. Cleaning:
   
   • Removed missing values and duplicate records
   
   • Converted diagnosis to factor variable
   
   • Eliminated irrelevant columns
   
2. Feature Scaling:
   
   • Applied Min-Max normalization to scale features to [0,1] range
   
3. Feature Selection:

   • Used variance filtering (threshold=0.01)
   
   • Performed correlation analysis with target
   
   • Selected top 10 most predictive features
   
#### Machine Learning Models

1. Support Vector Machine (SVM):

   • Gaussian kernel for nonlinear classification
  
   • Optimized C and gamma parameters
  
2. Decision Tree (CART):

   • Gini index for splitting criterion
  
   • Cost complexity pruning
  
3. Random Forest:

   • 500 decision trees
  
   • Bootstrap sampling and random feature selection
  
4. Adaboost:

   • 100 weak learners
  
   • Adaptive sample weighting

### Results
#### Performance Comparison
Model            | Accuracy | Macro Precision | Macro Recall | Macro F1-Score
-----------------|----------|-----------------|--------------|---------------
SVM              | 97.35%   | 96.96%          | 97.40%       | 97.17%
Decision Tree    | 94.69%   | 94.76%          | 93.83%       | 94.26%
Random Forest    | 93.81%   | 92.97%          | 94.10%       | 93.46%
Adaboost         | 94.69%   | 93.82%          | 95.29%       | 94.42%

#### Key Findings:

• SVM achieved the highest performance across all metrics

• Decision Tree and Adaboost showed comparable results

• Random Forest performed slightly worse but still maintained >93% accuracy


### Installation
#### Required R packages:
```r
install.packages(c("tidyverse", "moments", "corrplot", "ggplot2", "ggfortify", "ggcorrplot", "caret", "e1071", "rpart", "randomForest", "gbm", "yardstick", "dplyr"))
```

### Usage Instructions
1. Data Preparation:

   • Download the dataset and name it "Cancer_Data_Raw.csv"
   
   • Place in the project's Data directory
   
2. Running the Analysis:
   
   • Execute scripts in the following order:
   
     ```r
     source("Scripts/data_processing.R")
     source("Scripts/feature_engineering.R")
     source("Scripts/model_training.R")
     source("Scripts/evaluation.R")
     ```
     
   • Alternatively, run the RMarkdown report (Report/Data-Analysis-Report.rmd) for interactive analysis
   
3. Output:

   • Cleaned dataset (Data/Cancer_Data_Processed.csv)
   
   • Normalized dataset (Data/Cancer_Data_Normalized.csv)
   
   • Final dataset for building models (Data/Cancer_Data_Final.csv)
   
   • Data analysis report (Report/Data-Analysis-Report.pdf)


### Important Notes
1. The preprocessing pipeline is critical for model performance
2. Training time varies significantly by model (SVM typically slowest)
3. Results are specific to breast cancer diagnosis
4. For clinical applications, further validation with larger datasets is recommended

### License
This project is available under the MIT License.
