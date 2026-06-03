# Literature Retrieval and Citation Standard
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Goal

This module supports **research design justification**, not citation padding. The agent should retrieve a compact, decision-relevant literature set that helps justify:
- why the selected disease pair and shared-biomarker direction are biologically plausible
- why the selected DEG / overlap / PPI / ROC / immune / validation modules are methodologically defensible
- whether there are similar published dual-disease shared-biomarker studies
- where the novelty gap may lie

---

## Mandatory Search Categories

### 1. Background Biology
Retrieve references that establish the relevance of the disease-pair or shared-mechanism combination.

Examples:
- intracranial aneurysm and abdominal aortic aneurysm shared vascular-remodeling biology
- inflammatory comorbidity-linked extracellular matrix programs
- immune-associated shared biomarkers across two related diseases

### 2. Method Justification
Retrieve core references for the methods actually used in the selected plan. Only cite methods that appear in the workflow.

Examples:
- limma / DESeq2 differential expression
- overlap-concordance rules or meta-analytic shared-signal logic
- STRING / Cytoscape / cytoHubba
- ROC analysis in biomarker studies
- CIBERSORT / ssGSEA / GSVA if present

### 3. Similar-Study Precedents
Retrieve studies that resemble the planned analysis in at least one of these dimensions:
- same disease pair
- same shared-biomarker direction
- same DEG → overlap / PPI / hub-gene logic
- same validation or immune-context framing

### 4. Resource / Dataset References
When a dataset or resource is central to the plan, retrieve its canonical citation if useful.

Examples:
- GEO resource paper
- STRING paper
- CIBERSORT or GSVA paper

---

## Hard Requirements

1. **Never fabricate references.**
2. **Only list formally verified references** with a DOI, PMID, PMCID, or stable direct link.
3. If browsing/search is unavailable, explicitly say so and output:
   - a search strategy
   - database targets
   - query logic
   - evidence gaps still needing confirmation
4. If no reliable reference is found for a needed module, write:
   - **"no directly verified reference identified yet"**
5. Do not pad the literature pack with generic unrelated citations.

---

## Required Output Categories for Section I

### I1. Core background references
Use to justify disease pair, shared biology, and why a common biomarker question is plausible.

### I2. Method justification references
Only methods actually used in the plan.

### I3. Similar-study precedent references
Dual-disease, comorbidity, or shared-signal transcriptome studies with a comparable paper logic.

### I4. Search strategy and evidence gaps
State what was searched, what was found, and what remains missing.

---

## Reference Item Format

For each item, include:
- **Citation status:** verified only
- **Article type:** original study / review / methods / resource paper
- **Why included:** what design choice it supports
- **Relevance note:** one line tied to a concrete module in the workflow
- **Identifier:** DOI, PMID, PMCID, or stable direct link

---

## What This Module Is Not

This is **not**:
- a long narrative literature review
- a background-only introduction section
- a place to guess references from memory
- a substitute for verification
