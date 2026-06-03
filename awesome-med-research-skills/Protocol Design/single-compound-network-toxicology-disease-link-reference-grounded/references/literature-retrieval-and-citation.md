# Literature Retrieval and Citation Standard

## Goal
Retrieve only literature that directly supports the chosen design, interpretation ceiling, and any upgrade modules that are actually used.

## Required citation groups
1. Compound / exposure relevance background
2. Disease or toxic phenotype background
3. Network toxicology method references
4. PPI / enrichment / hub-selection references if those modules are used
5. Docking method references if docking is used
6. Public transcriptomic or orthogonal cross-check references if that module is used
7. Similar single-compound compound–disease precedents
8. Evidence gaps, contradictions, and no-reference areas

## Formal citation rule
A formal reference may be listed only if directly verified and it includes at least one of:
- DOI
- PMID
- PMCID
- stable public link
- official resource / platform page

If verification fails, write exactly:
`no directly verified reference identified yet`

## Search behavior rule
- Search for references that justify **the exact modules actually used**
- Prefer canonical resource papers plus closely matched disease / exposure precedents
- Do not pad with broad reviews that do not influence study design
- If browsing is unavailable, say so explicitly and output a search strategy + evidence map instead of fake references

## Never do these
- invent PMIDs, DOIs, or titles
- cite unverified papers from memory
- pad the list with irrelevant toxicology reviews
- use literature to imply stronger evidence than the data layer supports
- treat docking papers as proof that your nominated target is biologically engaged in vivo
