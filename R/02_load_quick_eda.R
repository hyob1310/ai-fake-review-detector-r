# R/02_load_quick_eda.R
# Load dataset + quick EDA

# Make sure you're running from the project root:
# setwd("C:/Users/hyob1/ai-fake-review-detector-r")

library(arrow)

path <- "data/fake_reviews.parquet"

if (!file.exists(path)) {
  stop("Dataset not found. Run source('R/01_download_data.R') first.")
}

df <- read_parquet(path)

# 1) Basic info
cat("Rows:", nrow(df), "\n")
cat("Cols:", ncol(df), "\n\n")

cat("Column names:\n")
print(names(df))

cat("\nFirst 3 rows:\n")
print(head(df, 3))

# 2) Look at the label column (we’ll confirm exact name)
# Try common label names:
possible_labels <- c("label", "labels", "class", "target", "is_fake", "generated", "fake")
label_col <- possible_labels[possible_labels %in% names(df)][1]

cat("\nDetected label column:", label_col, "\n")

if (is.na(label_col)) {
  cat("\nI couldn't auto-detect the label column.\n")
  cat("Please look at the column names printed above and tell me which one is fake/real.\n")
} else {
  cat("\nClass balance:\n")
  print(table(df[[label_col]], useNA = "ifany"))
}

# 3) Look at the text column (we’ll confirm exact name)
possible_text <- c("text", "review", "review_text", "content", "sentence")
text_col <- possible_text[possible_text %in% names(df)][1]

cat("\nDetected text column:", text_col, "\n")

if (!is.na(text_col)) {
  cat("\nExample reviews:\n")
  print(df[[text_col]][1:5])
} else {
  cat("\nI couldn't auto-detect the text column.\n")
  cat("Please tell me which column contains the review text.\n")
}
