# ai-fake-review-detector-r
NLP-based fake review detection using machine learning in R (TF-IDF, Logistic Regression, Random Forest)

## Results

Two machine learning models were trained to detect deceptive reviews
using TF-IDF text features.

| Model | AUC |
|------|-----|
| Logistic Regression (Ridge) | **0.9334** |
| Random Forest (Top 1,000 terms) | 0.9249 |

Logistic regression achieved the highest AUC while remaining
computationally efficient and interpretable. Although the Random Forest
model performed well, it required dimensionality reduction and higher
computational cost.

Based on these results, logistic regression was selected as the preferred
model for large-scale fake review detection.
