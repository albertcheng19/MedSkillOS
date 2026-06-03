# Specialized Evaluation — Category 3: Data Analysis

This rubric contributes up to **60 points** to the per-output total score.

---

## Scene Override — Basic Evaluation Corrections for Category 3

> **These overrides apply only to Category 3 skills.** When a conflict exists between the criteria below and the corresponding criteria in `basic_evaluation.md`, the descriptions here take precedence.
>
> **Source:** Identified during audit of `differential-expression-analysis` (2026-04-02). Three criteria in `basic_evaluation.md` were found to systematically misclassify correct design decisions as defects when applied to scientific computing + agent-first skills.

### Override 1 — Fault Tolerance (Basic Evaluation 2.1)

In scientific computing pipelines where downstream steps have hard dependencies on upstream results, **stopping at the source of failure is the correct defensive design**. Do not penalize a skill for calling `stop()` or raising a hard error when continuing would propagate invalid data through the analysis.

| Correct design | Incorrect interpretation |
|---|---|
| Hard stop when no significant genes found, preventing invalid visualization inputs | "Skill should degrade gracefully and attempt to continue" |
| Hard stop on sample mismatch, preventing silently wrong group assignments | "Skill should auto-correct or fuzzy-match sample IDs" |

Score Fault Tolerance based on whether the failure mode is **caught and reported clearly**, not on whether the skill attempts to continue past it.

### Override 2 — Forgiveness (Basic Evaluation 5.2)

In scientific computing, **strict input validation is a data integrity guarantee, not a usability defect**. Auto-correcting or fuzzy-matching inputs (e.g. case-insensitive sample ID matching, BOM stripping, quote normalization) risks silently producing biologically incorrect results. Data preparation is the responsibility of the upstream pipeline, not the analysis skill.

Do not deduct points for strict input rejection. Instead, evaluate whether:
- The error message clearly identifies what is wrong
- The skill uses structured error codes that an agent can parse and act on
- The documentation states input requirements explicitly

### Override 3 — Recoverability (Basic Evaluation 2.3)

Category 3 skills are typically invoked in **agent-first execution contexts** (Mode B or D), where the caller is an AI agent rather than a human reading terminal output. In this context, structured error codes (e.g. `SKILL_*` prefixes) are the correct interface design — they give the agent everything it needs to diagnose and retry. Inline human-readable recovery guidance is redundant and should not be required for full marks.

Score Recoverability based on whether:
- Errors surface a structured, parseable code
- The error message identifies the specific failure (file, sample IDs, parameter)
- Re-running with corrected inputs produces consistent results (idempotency)

---

| **Core Specialized Dimension** | **Evaluation Focus & Risk Avoidance** | **Scoring Rubric** | **Max** |
|---|---|---|---|
| **1. Methodological Validity** | **Model fit**: alignment between statistical method and data type / distribution. | **16–20 pts**: Model is perfectly suited, precisely handles complex statistical challenges; **10–15 pts**: Method has no principled errors but does not consider optimal distribution or robustness; **0–9 pts**: Statistical method is misused, rendering conclusions invalid. | 20 |
| **2. Code Executability** | **Engineering quality**: environment dependencies, code logic, and result accuracy. | **12–15 pts**: Code is "out-of-the-box", logic is tight, output is precise; **8–11 pts**: Needs minor adjustments, or has non-result-affecting redundancy; **0–7 pts**: Code fails to run or has critical logic bugs. | 15 |
| **3. Data Quality Control** | **Basic handling of outliers and missing values**. | **9–10 pts**: Outliers and missing values are identified and handled with documented procedures; **5–8 pts**: Basic handling logic is correct but coverage is limited; **0–4 pts**: Quality control is ignored; contaminated data fed directly into analysis. | 10 |
| **4. Reproducibility & Robustness** | **Error handling**: fixed seed, error recognition, and graceful degradation (no crashes). | **8–10 pts**: Reproduction steps are clear, error feedback is intelligent, degradation logic is present; **5–7 pts**: Reproducibility is acceptable but only simple error hints are provided; **0–4 pts**: Completely non-reproducible or crashes on error. | 10 |
| **5. Security** | **Prevention of sensitive data leakage and destructive operations**. | **Pass/Fail hard check** (any leak of keys, PHI, or destructive commands like `rm -rf` → immediate 0). **Full 5 pts**: No sensitive data exposed, no dangerous operations present. | 5 |
| **Total** | **Robustness and accuracy of the Skill in computation and analysis tasks** | — | **60** |
