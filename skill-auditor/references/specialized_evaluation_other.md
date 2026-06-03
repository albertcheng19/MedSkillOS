# Specialized Evaluation — Category 5: Other (General / Non-Research)

This rubric contributes up to **60 points** to the per-output total score.

---

## Execution Mode Awareness Note

> Category 5 covers a wide range of skill types. Before scoring Basic Evaluation criteria, identify the skill's **execution mode** (from Step 3.2) and **primary user model**:
>
> - **Mode A (Direct / conversational):** The standard criteria in `basic_evaluation.md` apply in full. Forgiveness, Recoverability, and Fault Tolerance should be evaluated as written.
> - **Mode B / C / D (CLI, API, or Hybrid) + agent-first context:** The skill is invoked by an AI agent rather than a human. In this case, consider applying the same scene overrides defined in `specialized_evaluation_data_analysis.md` (Overrides 1–3) — specifically, do not penalize structured error codes for lacking inline human-readable guidance, and do not penalize strict input validation if the skill's domain requires data integrity guarantees.
>
> If uncertain about the user model, default to the standard `basic_evaluation.md` criteria.

---

| **Core Specialized Dimension** | **Evaluation Focus & Risk Avoidance** | **Scoring Rubric** | **Max** |
|---|---|---|---|
| **1. Task Completion** | **Core objective**: whether all requirements stated in the user instruction are fully covered. | **16–20 pts**: Task is 100% covered with no omissions; **10–15 pts**: Core task is completed but edge details are missing; **0–9 pts**: Core objective is not achieved. | 20 |
| **2. Factual Accuracy** | **Information quality**: content is correct and internally logically consistent. | **16–20 pts**: No factual errors; internally self-consistent; **10–15 pts**: Minor information inaccuracies that do not affect usability; **0–9 pts**: Serious hallucinations or factual errors present. | 20 |
| **3. Format & Usability** | **Delivery quality**: well-structured, clean layout, directly ready to use. | **8–10 pts**: Layout is polished, structure is excellent, no user adjustment needed; **5–7 pts**: Format is acceptable with minor cleanup required; **0–4 pts**: Format is chaotic and unreadable. | 10 |
| **4. Scope Adherence** | **Boundary awareness**: strictly follows the scope defined in the Skill's System Prompt. | **8–10 pts**: Role positioning is highly precise with no overreach or breaking character; **5–7 pts**: Occasionally deviates from the setting but recovers quickly; **0–4 pts**: Severely violates the Skill's defined scope. | 10 |
| **Total** | **Overall execution capability of the Skill on general / non-academic tasks** | — | **60** |
