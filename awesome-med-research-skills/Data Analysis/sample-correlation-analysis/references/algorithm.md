# Correlation Analysis Algorithm Details

## Statistical Methods

### 1. Pearson Correlation

Pearson correlation measures the linear relationship between two continuous variables.

**Formula:**
```
r = Σ[(x_i - x̄)(y_i - ȳ)] / √[Σ(x_i - x̄)² Σ(y_i - ȳ)²]
```

**Test statistic (for hypothesis testing):**
```
t = r × √[(n-2)/(1-r²)]
df = n-2
```

**Confidence interval:**
```
CI = tanh(arctanh(r) ± z_{α/2} × SE)
SE = 1/√(n-3)
```

**Assumptions:**
- Variables are continuous and approximately normally distributed
- Linear relationship between variables
- Homoscedasticity (constant variance along regression line)
- Independence of observations
- No significant outliers

**Use Cases:**
- Testing linear relationship between two continuous variables
- When data meet normality assumptions
- When relationship appears linear in scatter plot

### 2. Spearman Rank Correlation

Spearman correlation measures monotonic relationship (whether linear or not) between two variables based on ranks.

**Formula:**
```
ρ = 1 - [6 × Σd_i²] / [n(n²-1)]
```
where d_i = rank(x_i) - rank(y_i)

**Alternative formula (with ties):**
```
ρ = cov(rank(x), rank(y)) / [sd(rank(x)) × sd(rank(y))]
```

**Test statistic (for hypothesis testing, n > 10):**
```
t = ρ × √[(n-2)/(1-ρ²)]
df = n-2
```

**Implementation note:** This CLI calls `cor.test(..., exact = FALSE)` for Spearman correlation, so it uses the asymptotic test rather than exact permutation inference.

**Assumptions:**
- Variables can be continuous or ordinal
- Relationship is monotonic (consistently increasing or decreasing)
- No assumption of normality
- Observations are independent

**Use Cases:**
- Variables not normally distributed
- Presence of outliers
- Ordinal data
- Monotonic but non-linear relationships

## Parameter Description

### Correlation Method (--method)
- `pearson`: Pearson product-moment correlation (default)
- `spearman`: Spearman rank correlation

### Alternative Hypothesis (--alternative)
- `two.sided`: Two-tailed test, tests if correlation differs from zero (default)
- `less`: One-sided test for negative correlation
- `greater`: One-sided test for positive correlation

### Confidence Level (--conf_level)
- Default: 0.95 (95% confidence interval)
- Range: Value between 0 and 1
- Meaning: Probability that the true correlation coefficient is contained in the interval

## Result Interpretation

### Key Statistics
- **Correlation coefficient (r or ρ)**: Measure of association strength and direction
  - Range: -1 to +1
  - Interpretation:
    - ±0.00-0.19: Very weak
    - ±0.20-0.39: Weak
    - ±0.40-0.59: Moderate
    - ±0.60-0.79: Strong
    - ±0.80-1.00: Very strong
- **p-value**: Probability of observing the current correlation or more extreme under null hypothesis (ρ=0)
- **Confidence interval**: Range of plausible values for the true correlation coefficient
- **Sample size**: Number of observation pairs used in analysis

### Significance Decision
- p < 0.05: Statistically significant correlation, reject null hypothesis
- p ≥ 0.05: Not significant, fail to reject null hypothesis
- Note: Statistical significance does not equal practical importance; consider effect size (correlation coefficient) and domain knowledge

## Hypothesis Testing Steps

1. **Formulate Hypotheses**
   - Null hypothesis H₀: ρ = 0 (no correlation)
   - Alternative hypothesis H₁: ρ ≠ 0, ρ < 0, or ρ > 0 (based on --alternative parameter)

2. **Calculate Correlation Coefficient**
   - Compute Pearson r or Spearman ρ based on selected method

3. **Calculate Test Statistic**
   - Compute t-statistic from correlation coefficient and sample size

4. **Determine p-value**
   - Calculate p-value from t-distribution (Pearson) or exact/approximate distribution (Spearman)

5. **Make Decision**
   - p < α (typically 0.05): Reject null hypothesis, conclude significant correlation
   - p ≥ α: Fail to reject null hypothesis, insufficient evidence for correlation

6. **Compute Confidence Interval**
   - Provide credible range for correlation coefficient estimate

## Method Selection Guide

### Choose Pearson Correlation when:
- Both variables are continuous
- Data are approximately normally distributed
- Relationship appears linear in scatter plot
- No significant outliers
- Interested in linear relationship specifically

### Choose Spearman Correlation when:
- Variables are ordinal
- Data are not normally distributed
- Presence of outliers
- Relationship is monotonic but not necessarily linear
- Data contain tied ranks
- More robust measure needed

## Notes

### Data Requirements
1. **Sample Size**: Minimum 3 observation pairs for correlation calculation. Larger samples provide more reliable estimates.
2. **Missing Data**: Rows with missing values in either variable are excluded (pairwise deletion).
3. **Outliers**: Pearson correlation is sensitive to outliers; Spearman is more robust.
4. **Linearity**: Pearson correlation only measures linear relationships; non-linear relationships may show weak Pearson but strong Spearman correlation.

### Assumption Checking
1. **Normality**: Check with Shapiro-Wilk test or visual inspection (Q-Q plots)
2. **Linearity**: Check with scatter plot
3. **Homoscedasticity**: Check with residual plot (for Pearson)

### Effect Size Interpretation
- **Small effect**: |r| = 0.1 (explains 1% of variance)
- **Medium effect**: |r| = 0.3 (explains 9% of variance)
- **Large effect**: |r| = 0.5 (explains 25% of variance)

### Limitations
- Correlation does not imply causation
- Restricted range can attenuate correlation
- Non-linear relationships may be missed by Pearson correlation
- Sample correlation is sensitive to sample characteristics
