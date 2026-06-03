# Workload Configurations

## Lite
- Goal: establish whether one compound plausibly intersects one disease-relevant or toxicity-relevant molecular network
- Necessary: compound standardization, target retrieval, disease / phenotype target retrieval, overlap construction, basic enrichment, one simple PPI branch
- Optional: one very limited docking branch if receptor structures are immediately available
- Forbidden unless explicitly upgraded: transcriptomic cross-check, ADMET, molecular dynamics, wet-lab validation
- Evidence ceiling: hypothesis generation and bridge-target nomination

## Standard
- Goal: produce a conventional single-compound network-toxicology manuscript backbone
- Necessary: overlap, hub analysis, enrichment, docking, focused references, conservative synthesis
- Optional: one limited external expression or toxicogenomic cross-check
- Evidence ceiling: prioritized mechanism model with supportive docking

## Advanced
- Goal: improve reviewer defensibility
- Necessary additions: stronger hub-ranking logic, one external validation layer such as GEO expression support, source-sensitivity checks, stricter evidence map
- Optional: AOP alignment, signature-coherence review
- Evidence ceiling: externally coherent compound–disease hypothesis

## Publication+
- Goal: manuscript-ready high-ambition package
- Necessary additions: multi-source robustness table, explicit claim-downgrade analysis, contradiction handling, stronger figure spine
- Optional: targeted molecular-dynamics follow-up only if docking is already justified and structure quality is acceptable
- Evidence ceiling: high-quality mechanistic prioritization, still not causal proof

## Minimal executable discipline
- Section G must remain a strict subset of Lite unless explicitly labeled as an upgraded minimal variant
- Advanced and Publication+ modules must be marked as upgrade-only when first introduced
- Any module with new dependencies must declare those dependencies before use
