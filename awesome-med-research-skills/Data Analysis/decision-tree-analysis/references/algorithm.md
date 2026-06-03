# Decision Tree and Feature Importance

This skill uses `rpart` to train a single decision tree.

## Modeling Flow

1. Load tabular data.
2. Remove excluded columns.
3. Keep the target plus remaining predictors.
4. Drop rows with missing values in modeling columns.
5. Convert character predictors to factors.
6. Infer task type in `auto` mode.
7. Split data into training and test sets.
8. Train an `rpart` tree.
9. Evaluate the fitted model on the test set.
10. Export feature importance ranking results.

## Task Type Logic

- `classification`: uses `rpart(..., method = "class")`
- `regression`: uses `rpart(..., method = "anova")`
- `auto`: numeric target with more than 10 unique values becomes regression; all other cases become classification

## Feature Importance Logic

The skill uses `model$variable.importance` from `rpart`.

Interpretation:

- A feature receives a larger score when it contributes more to impurity reduction across tree splits.
- Relative importance is computed as:

```text
relative_importance = importance / sum(all feature importances)
```

- Features not used by the final tree still appear in the output table with importance `0`.

## Evaluation Metrics

Classification output:

- `accuracy`
- `macro_precision`
- `macro_recall`
- `macro_f1`

Regression output:

- `rmse`
- `mae`
- `r_squared`

## Practical Notes

- A single decision tree is interpretable but may be unstable on small or noisy data.
- Feature importance shows model reliance, not causality.
- Strongly correlated features can dilute each other's importance.
- If the tree does not split, all feature importance scores may be zero.
