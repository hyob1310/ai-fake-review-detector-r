# 01_download_data.R
# This script downloads the fake reviews dataset into /data
# The data folder is ignored by git and not uploaded to GitHub

dir.create("data", showWarnings = FALSE)

url <- "https://huggingface.co/datasets/theArijitDas/Fake-Reviews-Dataset/resolve/main/data/train-00000-of-00001.parquet"
dest <- file.path("data", "fake_reviews.parquet")

if (!file.exists(dest)) {
  download.file(url, dest, mode = "wb")
  message("Dataset downloaded to data/fake_reviews.parquet")
} else {
  message("Dataset already exists")
}
