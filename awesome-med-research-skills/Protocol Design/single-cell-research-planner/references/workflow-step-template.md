# Workflow Step Template

## Dataset Disclaimer Rule
If any workflow step mentions a dataset, cohort, database, repository, accession, or public resource, the workflow section must begin with the following line exactly once before the first step:

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

## Recommended Workflow Skeleton
1. Clarify biological question and dominant study pattern
2. Define sample grouping and metadata requirements
3. Identify example dataset directions / repositories / candidate cohorts
4. Perform QC, filtering, and batch assessment
5. Build clustering and annotation framework
6. Run the main biological module(s)
7. Add one justified extension module if needed
8. Perform validation / robustness checks
9. Translate the signal into the intended biological or translational conclusion

## Important Rule
Do not include downstream steps that require sample-level replicate structure, outcome labels, treatment metadata, or paired design unless those dependencies were already specified.
