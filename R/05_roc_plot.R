# R/05_roc_plot.R
# Create ROC curve for logistic regression model

library(pROC)

# Load saved models and metrics
obj <- readRDS("data/models/models_and_metrics.rds")

logit_auc <- obj$metrics$logit_auc

# Reload test data + probabilities
features <- readRDS("data/processed/features.rds")

test <- features$test
x_test <- features$x_test_tfidf

# Extract logistic regression model
logit_model <- obj$logit_model
pos_class <- obj$pos_class

# Binary labels
y_test_bin <- ifelse(test$label == pos_class, 1, 0)

# Predict probabilities
logit_prob <- as.numeric(
  predict(logit_model, x_test, s = "lambda.min", type = "response")
)

# ROC curve
roc_obj <- roc(y_test_bin, logit_prob, quiet = TRUE)

# Create reports folder if needed
dir.create("reports", showWarnings = FALSE)

# Save plot
png("reports/roc_curve_logistic.png", width = 700, height = 600)
plot(
  roc_obj,
  col = "blue",
  lwd = 2,
  main = paste0("ROC Curve – Logistic Regression (AUC = ", round(logit_auc, 3), ")")
)
abline(a = 0, b = 1, lty = 2, col = "gray")
dev.off()

cat("ROC curve saved to reports/roc_curve_logistic.png\n")
