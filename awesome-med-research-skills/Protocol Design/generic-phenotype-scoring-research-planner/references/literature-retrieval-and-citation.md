# Literature Retrieval and Citation Standard
# generic-phenotype-scoring-research-planner

---

## Goal

This module supports **research design justification**, not citation padding. The agent should retrieve a compact, decision-relevant literature set that helps justify:
- why the disease and signature/phenotype matter biologically or clinically
- why DEG/signature-intersection, phenotype scoring, machine learning, immune infiltration, and scRNA-seq validation are methodologically defensible
- whether similar phenotype-oriented bioinformatics studies already exist
- where the novelty gap remains

---

## Mandatory Search Categories

### 1. Background Disease and Signature Relevance
### 2. Method Justification
### 3. Similar-Study Precedent
### 4. Resource / Dataset References

---

## Verification Rules

### Verified Citation (the only allowed formal citation status)
A reference may be listed as a formal citation **only when it is directly verified** from a trustworthy record such as:
- PubMed
- PubMed Central
- DOI / Crossref metadata
- official journal / publisher page
- official resource or platform page

Minimum required verified fields:
- title
- first author or consortium / group author
- journal or source
- year
- at least one persistent identifier or stable access path: **DOI, PMID, PMCID, PubMed link, PMC link, official resource page, or official publisher landing page**

### Forbidden Behavior
Do not:
- invent PMIDs or DOIs
- guess missing author lists
- infer journal / volume / issue / pages from memory alone
- output a formal citation without a DOI, PMID, PMCID, or direct stable link

## Output Format

### I1. Core Background References
### I2. Method Justification References
### I3. Similar-Study Precedents
### I4. Search Strategy and Evidence Gaps

If reliable references cannot be verified for some modules:
- say so clearly
- output **no directly verified reference identified yet** for that slot
