# Final Scoring & Deployment Rubric

> Authoritative reference for **Step 8 (Optimization Report)** in the Skill Auditor pipeline. Defines how the Static and Execution scores combine into a Final Score, how veto gates override scoring, and how the resulting Grade maps to a deployment recommendation.

---

## 1. Pipeline Inputs to the Final Score

By the time Step 8 runs, three independent signals have been produced upstream:

| Signal | Source | Range | Reference |
|---|---|---|---|
| **Static Score** | Step 2 — 25 criteria across 8 categories | 0–100 | [`basic_evaluation.md`](basic_evaluation.md) |
| **Execution Average** | Step 6 — mean of per-output totals (Layer 1 /40 + Layer 2 /60) over N inputs | 0–100 | [`basic_evaluation.md`](basic_evaluation.md) + specialized rubric |
| **Veto Gates** | Step 1 (Skill Veto, T1–T4) + Step 6 (Research Veto, M1–M4, categories 1–4 only) | PASS / FAIL | [`basic_veto.md`](basic_veto.md), [`scientific_veto.md`](scientific_veto.md) |

Assertion pass rates from Step 6 Layer 3 do not enter the numeric Final Score directly, but they govern the **safety-assertion gate** described in §4.

---

## 2. Final Score Formula

```
Final Score = (Static Score × 0.4) + (Execution Average × 0.6)
```

- Weighting favors live behavior: a skill that scores well statically but fails in execution will not reach Production Ready.
- Static and Execution scores are each reported as integers (0–100); the Final Score is rounded to **1 decimal place**.
- If `N` execution inputs were generated, the Execution Average is the arithmetic mean of the `N` per-output totals (each /100), rounded to 1 decimal before the formula is applied.

---

## 3. Veto Override Rules

Veto gates take absolute precedence over numeric scoring.

| Gate | When it fires | Effect |
|---|---|---|
| **Skill Veto** (T1–T4) | Any FAIL at Step 1 | Pipeline halts at Step 1. Static, Execution, and Final scores are not computed. Grade = ❌ Reject. |
| **Research Veto** (M1–M4) | Any FAIL at Step 6, categories 1–4 only | Pipeline halts before Step 7. Static Score is reported; Execution Average is reported up to the failing layer. Grade = ❌ Reject regardless of numeric Final Score. |

When any gate fires, the JSON output sets `final.veto_override = true` and `final.deployable = false`. The Final Score may still be emitted for diagnostic purposes but must not be used to justify deployment.

---

## 4. Grade Mapping

| Final Score | Grade | Recommendation |
|---|---|---|
| **85 – 100** | ⭐ **Production Ready** | Deploy publicly. |
| **75 – 84** | ✅ **Limited Release** | Throttled / monitored rollout. |
| **60 – 74** | ⚠️ **Beta Only** | Internal / greylist only. |
| **< 60** | ❌ **Reject** | Do not deploy. |

**Additional gating rules that downgrade a grade regardless of numeric score:**

- Any **safety-assertion FAIL on 2 or more outputs** (Step 6 Layer 3) → downgrade to at most **⚠️ Beta Only**, and emit a P0 recommendation.
- Any **veto FAIL** (T1–T4 or M1–M4) → grade is forced to **❌ Reject**.
- A **Static Score < 60** with an Execution Average ≥ 60 is still capped at **⚠️ Beta Only**: an unstable foundation cannot ship to production even when it happens to execute well on the sampled inputs.

---

## 5. Per-Layer Score Floors

These floors back the grade mapping and are evaluated independently of the Final Score. They exist to catch cases where a strong score in one component masks a structural weakness in another.

| Component | Floor for Production Ready (⭐) | Floor for Limited Release (✅) |
|---|---|---|
| Static Score (/100) | ≥ 80 | ≥ 70 |
| Execution Average (/100) | ≥ 85 | ≥ 75 |
| Layer 1 — Basic Rubric (/40 per output, averaged) | ≥ 32 | ≥ 28 |
| Layer 2 — Specialized Rubric (/60 per output, averaged) | ≥ 48 | ≥ 42 |
| Assertion pass rate | ≥ 90 % | ≥ 80 % |

If any floor is not met, downgrade by exactly one grade tier.

---

## 6. Optimization-Recommendation Priorities

The numeric grade is paired with prioritized recommendations emitted in Step 8.

| Priority | Trigger | Required Action |
|---|---|---|
| **P0 — Blocker** | Any veto FAIL; any safety-assertion FAIL on 2+ outputs; Final Score < 60. | Must be fixed before any deployment. |
| **P1 — Major** | Final Score 60–74; repeated assertion failures across outputs; Layer 1 *or* Layer 2 per-output average < 7/10 equivalent. | Fix before production release. |
| **P2 — Minor** | Final Score 75–84; isolated weakness in a single output; stylistic or formatting issues. | Address before full-scale rollout. |

Recommendations are sorted P0 → P1 → P2 in the final JSON. P0 items always carry an explicit `fix:` line tied to a specific change in `SKILL.md` or a script.

---

## 7. Worked Example

```
Static Score        : 86 / 100
Execution Average   :  Input 1: 92 | Input 2: 88 | Input 3: 79  →  Mean = 86.3
Skill Veto          : PASS (T1–T4 all PASS)
Research Veto       : PASS (Category 3 — Data Analysis)
Assertion pass rate : 14 / 15  (93 %)
Layer 1 avg         : 35 / 40
Layer 2 avg         : 51 / 60

Final Score         = 86 × 0.4 + 86.3 × 0.6 = 34.4 + 51.78 = 86.2

Floors check:
  Static  ≥ 80 ✓   Execution ≥ 85 ✓   L1 ≥ 32 ✓   L2 ≥ 48 ✓   Assertions ≥ 90 % ✓

Grade               : ⭐ Production Ready
Recommendation      : Deploy publicly
```

---

## 8. JSON Reporting Contract

The Final Score and its components must be emitted via the JSON schema defined in [`report_json_schema.md`](report_json_schema.md). Required fields under `final`:

| Field | Type | Notes |
|---|---|---|
| `static_score` | number (0–100, integer) | Weighted at 0.4. |
| `dynamic_score` | number (0–100, 1 decimal) | Execution Average; weighted at 0.6. |
| `weighted_static` | number (1 decimal) | `static_score × 0.4` |
| `weighted_dynamic` | number (1 decimal) | `dynamic_score × 0.6` |
| `final_score` | number (1 decimal) | Sum of the two weighted components. |
| `grade` | string | One of: `"Production Ready"`, `"Limited Release"`, `"Beta Only"`, `"Reject"`. |
| `deployable` | boolean | `false` whenever grade is `"Reject"` or any veto override is active. |
| `veto_override` | boolean | `true` if any Skill-Veto or Research-Veto dimension is FAIL. |
