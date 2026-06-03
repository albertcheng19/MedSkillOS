# Specialized Evaluation — Category 2: Protocol Design

This rubric contributes up to **60 points** to the per-output total score.

---

## Scene Override — Basic Evaluation Corrections for Category 2

> **These overrides apply only to Category 2 skills.** When a conflict exists between the criteria below and the corresponding criteria in `basic_evaluation.md`, the descriptions here take precedence.
>
> **Source:** Identified during audit of `differential-expression-analysis` (2026-04-02). The same three systematic biases found in Category 3 apply equally to Category 2, which shares the scientific computing and agent-first execution profile.

### Override 1 — Fault Tolerance (Basic Evaluation 2.1)

In protocol design skills, **rejecting contradictory or under-specified inputs is the correct behavior**. If parameters are mutually inconsistent (e.g. sample size incompatible with stated statistical power, or conflicting study design constraints), the skill should halt and report the conflict rather than generating a flawed protocol. A silently generated but scientifically invalid protocol is more harmful than a hard stop.

Do not penalize hard stops for invalid parameter combinations. Evaluate instead whether the conflict is clearly identified and reported.

### Override 2 — Forgiveness (Basic Evaluation 5.2)

Statistical and experimental design parameters (alpha, power, sample size, effect size) must be treated as exact inputs. **Auto-correcting or inferring missing parameters without explicit user confirmation risks producing protocols with wrong operating characteristics.** Input strictness is a scientific integrity requirement, not a usability defect.

Do not deduct points for rejecting ambiguous or incomplete parameter sets. Evaluate instead whether the skill clearly states which parameters are required and why.

### Override 3 — Recoverability (Basic Evaluation 2.3)

Category 2 skills operating in agent-first execution contexts (Mode B or D) should be evaluated on structured error code quality rather than inline human-readable guidance. See Category 3 Override 3 for the full rationale — the same reasoning applies here.

---

| **Core Specialized Dimension** | **Evaluation Focus & Risk Avoidance** | **Scoring Rubric** | **Max** |
|---|---|---|---|
| **1. Design Soundness** | **Goal alignment**: fit between research question, study type, and objective; avoidance of hard methodological flaws. | **16–20 pts**: Design is elegant, fully matches research objective with no logical gaps; **10–15 pts**: Plan is feasible but efficiency or rigor is suboptimal; **0–9 pts**: Design is fundamentally misaligned with the research objective. | 20 |
| **2. Evidence Hierarchy Matching** | **Causal evidence chain**: distinguishes association, mechanistic, and causal evidence, and matches appropriate methods. | **12–15 pts**: Evidence hierarchy is clear and method matching is highly rigorous; **8–11 pts**: Broadly distinguishes evidence types but logic is unclear in complex scenarios; **0–7 pts**: Severely conflates causal and associative evidence. | 15 |
| **3. Method Combination Logic** | **Tiered recommendations**: distinguishes essential methods, recommended methods, and enhancement methods (bonus). | **8–10 pts**: Combination is reasonable, trade-offs are justified, cost-effectiveness is balanced; **5–7 pts**: Methods are stacked without distinguishing core from auxiliary; **0–4 pts**: Methods are missing or the combination logic is incoherent. | 10 |
| **4. Validation & Robustness** | **Compliance & boundaries**: parameter transparency, privacy compliance, and boundary awareness. | **8–10 pts**: Steps and parameters are highly transparent; strong compliance and privacy awareness; **5–7 pts**: Basic compliance present but parameter descriptions are incomplete; **0–4 pts**: Compliance risks or black-box design present. | 10 |
| **5. Publication & Translation Awareness** | **Reviewer perspective**: identifies reviewer risks and avoids over-interpretation of results. | **4–5 pts**: Strong reviewer-defense awareness, conclusions are rigorous; **2–3 pts**: Conclusions occasionally trend toward exaggeration but risk is manageable; **0–1 pts**: Results are over-interpreted, posing serious academic risk. | 5 |
| **Total** | **Rigor of the Skill in scientific research architecture design** | — | **60** |
