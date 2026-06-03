# Dataset Recommendation and Disclaimer Rules

## Mandatory Dataset Disclaimer
If any workflow step mentions a dataset, cohort, database, repository, accession, or public resource, the workflow section must begin with the following line exactly once before the first step:

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

This disclaimer is mandatory and must not be omitted.

## Dataset Recommendation Rules
When recommending datasets or repositories:
- present them as **reference candidates only**
- state why they might fit the question
- state what must be checked before final selection
- distinguish **verified resource name** from **assumed suitability**
- do not invent accession IDs or metadata details

## What to State for Each Dataset Direction
Whenever possible, specify:
- tissue / disease relevance
- likely platform type or modality
- disease-control or subgroup structure needed
- metadata requirements (sample ID, treatment status, outcome, batch, timepoint)
- main risk (small sample size, weak metadata, no replicate structure, post-treatment only, etc.)

## Repository-Level Suggestions
It is acceptable to recommend repository types such as GEO, ArrayExpress, CellxGene, Human Cell Atlas, TISCH, or disease-focused atlases **as examples only** if direct dataset verification has not been done.

Never imply that the repository automatically contains a suitable dataset for the specific question.
