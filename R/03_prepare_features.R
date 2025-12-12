# R/03_prepare_features.R
# Clean text + create TF-IDF features for modeling

library(tidyverse)
library(arrow)
library(text2vec)
library(stopwords)

path <- "data/fake_reviews.parquet"
df <- read_parquet(path) %>% as_tibble()

# Keep only what we need for now
df <- df %>%
  transmute(
    category = as.character(category),
    rating   = as.numeric(rating),
    text     = as.character(text),
    label    = as.factor(label)
  ) %>%
  filter(!is.na(text), text != "", !is.na(label))

# Text cleaning function (simple + recruiter-friendly)
clean_text <- function(x) {
  x <- tolower(x)
  x <- gsub("[^a-z\\s]", " ", x)      # keep letters/spaces
  x <- gsub("\\s+", " ", x)          # collapse spaces
  trimws(x)
}

df$text_clean <- clean_text(df$text)

# Train/test split (80/20)
set.seed(42)
idx <- sample(seq_len(nrow(df)), size = floor(0.8 * nrow(df)))
train <- df[idx, ]
test  <- df[-idx, ]

# Tokenization + vocabulary
it_train <- itoken(train$text_clean, progressbar = FALSE)
it_test  <- itoken(test$text_clean,  progressbar = FALSE)

vocab <- create_vocabulary(it_train, stopwords = stopwords("en")) %>%
  prune_vocabulary(term_count_min = 5, doc_proportion_max = 0.5)

vectorizer <- vocab_vectorizer(vocab)

# Document-Term Matrix
dtm_train <- create_dtm(it_train, vectorizer)
dtm_test  <- create_dtm(it_test,  vectorizer)

# TF-IDF
tfidf <- TfIdf$new()
x_train_tfidf <- tfidf$fit_transform(dtm_train)
x_test_tfidf  <- tfidf$transform(dtm_test)

# Add numeric features (rating) as a simple extra signal
# (We’ll combine later; for now we save objects.)
dir.create("data/processed", showWarnings = FALSE)

saveRDS(list(
  train = train,
  test = test,
  x_train_tfidf = x_train_tfidf,
  x_test_tfidf = x_test_tfidf,
  vocab = vocab
), file = "data/processed/features.rds")

cat("Saved features to data/processed/features.rds\n")
cat("Train rows:", nrow(train), " Test rows:", nrow(test), "\n")
cat("TF-IDF train matrix dims:", dim(x_train_tfidf), "\n")
