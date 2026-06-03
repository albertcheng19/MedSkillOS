# Basic Evaluation Criteria
# Framework: ISO 25010 · OpenSSF · Shneiderman · Agent-Specific Heuristics
# 8 Categories · 25 Criteria · 0–4 per criterion · 100 points total

> Score each criterion 0–4 using the level descriptions below.
> Sum all 25 scores for the Basic Evaluation total (max 100).
> This replaces the old 4×10 rubric.

---

## Category 1 — Functional Suitability (ISO 25010) · max 12

### 1.1 Completeness
Does the skill cover all the use cases its description promises?

| Score | Description |
|---|---|
| 4 | All promised use cases are covered with clear, complete instructions |
| 3 | Most use cases covered; one minor gap or ambiguity |
| 2 | Core case covered but 2–3 stated use cases are missing or vague |
| 1 | Only handles a narrow subset of what it claims |
| 0 | Major stated use cases are absent or broken |

### 1.2 Correctness
Are the skill's instructions, commands, and outputs factually accurate?

| Score | Description |
|---|---|
| 4 | All instructions are accurate, verifiable, and produce correct results |
| 3 | Mostly correct; minor factual imprecision that doesn't break core use |
| 2 | Some inaccuracies that could mislead or produce wrong outputs |
| 1 | Significant factual errors that would regularly cause failures |
| 0 | Core instructions are wrong or dangerous |

### 1.3 Appropriateness
Is the skill's approach the right fit for its stated task, or over/under-engineered?

| Score | Description |
|---|---|
| 4 | Approach is well-matched: not overkill, not underpowered for the task |
| 3 | Mostly appropriate; slightly over- or under-scoped in one area |
| 2 | Noticeably mismatched — either too complex or too shallow for the task |
| 1 | Fundamental mismatch between the problem and the chosen approach |
| 0 | Approach is wrong for the task type |

---

## Category 2 — Reliability (ISO 25010) · max 12

### 2.1 Fault Tolerance
Does the skill gracefully handle unexpected inputs, missing files, or API failures?

| Score | Description |
|---|---|
| 4 | Explicit handling for all major failure modes; fallbacks documented |
| 3 | Handles most failures; one or two edge cases missing |
| 2 | Partial handling; skill breaks silently on several failure modes |
| 1 | Almost no error handling; fails loudly or incorrectly on edge cases |
| 0 | No fault tolerance; skill is brittle by design |

### 2.2 Error Reporting
When something goes wrong, does the skill surface clear, actionable error information?

| Score | Description |
|---|---|
| 4 | Errors are specific, human-readable, and include recovery suggestions |
| 3 | Errors are reported clearly, but recovery guidance is minimal |
| 2 | Some errors caught but messages are cryptic or incomplete |
| 1 | Errors surface as raw stack traces or confusing output |
| 0 | Errors are swallowed silently or not reported at all |

### 2.3 Recoverability
Can a user recover or retry after a failure without losing work?

| Score | Description |
|---|---|
| 4 | Skill is idempotent or provides clear retry/rollback path |
| 3 | Recovery is possible with minor effort; partial idempotency |
| 2 | Recovery is unclear; some state may be lost on failure |
| 1 | Failures leave the system in an inconsistent or unusable state |
| 0 | Failures are unrecoverable without manual intervention |

---

## Category 3 — Performance & Context Efficiency (ISO 25010 + Agent) · max 8

### 3.1 Token Cost
Does the skill avoid loading unnecessary content into the context window?

| Score | Description |
|---|---|
| 4 | Progressive disclosure used correctly; only needed content loaded per step |
| 3 | Mostly efficient; one or two references loaded earlier than needed |
| 2 | Some bloat — large references loaded upfront without conditional logic |
| 1 | Most content loaded at once; context window poorly managed |
| 0 | No awareness of token cost; entire skill corpus always in context |

### 3.2 Execution Efficiency
Does the skill avoid redundant steps, unnecessary tool calls, or circular loops?

| Score | Description |
|---|---|
| 4 | Workflow is linear and minimal; each step has a clear purpose |
| 3 | Mostly efficient; one redundant step or avoidable round-trip |
| 2 | Several redundant operations or unnecessary steps present |
| 1 | Workflow is bloated or loops back unnecessarily |
| 0 | Skill is actively inefficient; causes excessive tool calls or context waste |

---

## Category 4 — Agent Usability (Shneiderman · Gerhardt-Powals) · max 16

### 4.1 Learnability
Can Claude (or another agent) understand and correctly apply this skill from a cold start?

| Score | Description |
|---|---|
| 4 | Instructions are immediately clear without prior context; no ambiguity |
| 3 | Mostly clear; one area requires re-reading or inference |
| 2 | Requires inference for multiple steps; some instructions are implicit |
| 1 | An agent would frequently misapply this skill without trial and error |
| 0 | Instructions are too vague, contradictory, or incomplete to follow |

### 4.2 Consistency
Are terminology, formatting, and step patterns consistent throughout the skill?

| Score | Description |
|---|---|
| 4 | Fully consistent naming, format, and structure throughout |
| 3 | Mostly consistent; 1–2 terminology or formatting inconsistencies |
| 2 | Noticeable inconsistencies that could confuse an agent |
| 1 | Significant inconsistency — different names for the same concept, conflicting formats |
| 0 | No internal consistency; each section uses different conventions |

### 4.3 Feedback Design
Does the skill specify what outputs or confirmations to produce at key steps?

| Score | Description |
|---|---|
| 4 | Output format and confirmation points clearly specified at each step |
| 3 | Most steps have clear output expectations; one or two are implicit |
| 2 | Outputs loosely defined; an agent would have to guess at format |
| 1 | Almost no output specifications; skill is output-agnostic by accident |
| 0 | Skill provides no guidance on what to output or when |

### 4.4 Error Prevention
Does the skill proactively warn against common mistakes or dangerous operations?

| Score | Description |
|---|---|
| 4 | Common failure modes explicitly called out with preventive guidance |
| 3 | Most pitfalls addressed; one common mistake not mentioned |
| 2 | Some warnings present but major pitfalls are unaddressed |
| 1 | Skill proceeds naively without warning the agent of risk areas |
| 0 | No preventive guidance; skill could cause significant harm if misapplied |

---

## Category 5 — Human Usability (Tognazzini · Norman) · max 8

### 5.1 Discoverability
Would a human user naturally phrase a request in a way that triggers this skill?

| Score | Description |
|---|---|
| 4 | Description uses natural trigger language aligned with how users actually ask |
| 3 | Mostly discoverable; one trigger phrasing gap |
| 2 | Trigger language is too formal or technical; users might not find it |
| 1 | Description is written for developers, not users; hard to trigger naturally |
| 0 | Description is so abstract or internal that real users would never trigger it |

### 5.2 Forgiveness
Does the skill handle slight variations, typos, or off-spec inputs gracefully?

| Score | Description |
|---|---|
| 4 | Skill degrades gracefully; handles variants and ambiguous inputs with clarification |
| 3 | Handles most variations; one input type causes failure |
| 2 | Rigid; minor deviations from expected input cause poor or no output |
| 1 | Fails on any input that doesn't match the documented format exactly |
| 0 | Skill is fragile; breaks on the slightest input variation |

---

## Category 6 — Security (ISO 25010 + OpenSSF) · max 12

### 6.1 Credential Safety
Does the skill avoid hardcoding secrets or logging sensitive data?

| Score | Description |
|---|---|
| 4 | No hardcoded secrets; env var pattern documented; no credential logging |
| 3 | Secrets externalized but env var documentation incomplete |
| 2 | Partial externalization; at least one credential appears hardcoded or logged |
| 1 | Credentials handled carelessly; significant exposure risk |
| 0 | Secrets hardcoded in plain text in SKILL.md or scripts |

### 6.2 Input Validation
Does the skill validate or sanitize user-provided inputs before using them?

| Score | Description |
|---|---|
| 4 | All user inputs validated before use; injection vectors addressed |
| 3 | Most inputs validated; one field lacks sanitization |
| 2 | Input handling is partial; several unvalidated fields present |
| 1 | Inputs passed through without validation |
| 0 | No input validation; skill is vulnerable to injection attacks |

### 6.3 Data Safety
Does the skill minimize data retention and avoid exposing sensitive information?

| Score | Description |
|---|---|
| 4 | Explicit data minimization; no sensitive data logged or retained unnecessarily |
| 3 | Data handling is mostly safe; minor retention issue |
| 2 | Some sensitive data logged or cached without clear necessity |
| 1 | Significant data exposure risk in the skill's normal operation |
| 0 | Skill actively stores or surfaces sensitive data insecurely |

---

## Category 7 — Maintainability (ISO 25010) · max 12

### 7.1 Modularity
Is the skill broken into well-separated sections, files, or steps?

| Score | Description |
|---|---|
| 4 | Clean separation of concerns; each file/section has one clear responsibility |
| 3 | Mostly modular; one area does too many things |
| 2 | Some modularity but several concerns are entangled |
| 1 | Monolithic structure; hard to update one part without touching everything |
| 0 | No separation of concerns |

### 7.2 Modifiability
How easy is it to update the skill's behavior without breaking other parts?

| Score | Description |
|---|---|
| 4 | Changes are isolated; clear extension points documented |
| 3 | Mostly easy to modify; one tightly coupled area |
| 2 | Modifying one section often requires changes elsewhere |
| 1 | Skill is brittle; any change has broad ripple effects |
| 0 | Modifications are nearly impossible without rewriting from scratch |

### 7.3 Testability
Does the skill's design support testing or verification of its outputs?

| Score | Description |
|---|---|
| 4 | Outputs are deterministic and verifiable; test cases or example inputs provided |
| 3 | Mostly testable; outputs are clear but no example test cases included |
| 2 | Some steps are hard to verify; outputs are partially observable |
| 1 | Skill is largely untestable; outputs are opaque or non-deterministic |
| 0 | No path to verify whether the skill worked correctly |

---

## Category 8 — Agent-Specific Quality · max 20

### 8.1 Trigger Precision
Does the description trigger the skill at the right time — not too broad, not too narrow?

| Score | Description |
|---|---|
| 4 | Trigger hits exactly the right use cases; no false positives or negatives expected |
| 3 | Mostly precise; minor over- or under-triggering risk |
| 2 | Noticeably too broad (triggers on unrelated tasks) or too narrow (misses real cases) |
| 1 | Significantly miscalibrated; would trigger for wrong tasks or fail to trigger when needed |
| 0 | Description is so vague or wrong that triggering is unpredictable |

### 8.2 Progressive Disclosure
Is information layered correctly — SKILL.md concise, with depth in references/scripts?

| Score | Description |
|---|---|
| 4 | SKILL.md ≤ 500 lines; detailed content in references/; scripts for complex logic |
| 3 | Mostly correct layering; SKILL.md slightly long or one reference missing |
| 2 | SKILL.md is bloated OR references exist but aren't used effectively |
| 1 | All content in SKILL.md; no references or scripts despite complexity |
| 0 | No layering; massive monolithic SKILL.md with no supporting files |

### 8.3 Composability
Can this skill be used alongside or invoked by other skills cleanly?

| Score | Description |
|---|---|
| 4 | Skill has clean inputs/outputs and documented integration points |
| 3 | Composable with minor friction |
| 2 | Some hard dependencies that make composition awkward |
| 1 | Skill assumes full context ownership; hard to compose |
| 0 | Skill is incompatible with composition patterns |

### 8.4 Idempotency
Does running the skill multiple times on the same input produce consistent results?

| Score | Description |
|---|---|
| 4 | Fully idempotent; re-runs are safe and produce the same result |
| 3 | Mostly idempotent; one side-effect on repeat runs |
| 2 | Partial idempotency; re-runs may produce different or conflicting outputs |
| 1 | Re-running causes state corruption or duplicate side-effects |
| 0 | Skill is explicitly non-idempotent without warning |

### 8.5 Escape Hatches
Does the skill tell the agent when NOT to proceed, or how to hand off to the human?

| Score | Description |
|---|---|
| 4 | Clear stop conditions, out-of-scope signals, and human handoff guidance |
| 3 | Some escape hatches; one common out-of-scope case not addressed |
| 2 | Skill tries to handle everything; minimal out-of-scope guidance |
| 1 | No escape hatches; skill proceeds regardless of context |
| 0 | Skill will attempt to execute even when it clearly shouldn't |

---

## Score Interpretation

| Total | Grade |
|---|---|
| 90–100 | Excellent — Publish confidently |
| 80–89 | Good — Publishable, document known issues |
| 70–79 | Acceptable — Fix P0s before publishing |
| 60–69 | Needs Work — Fix P0 + P1 before publishing |
| < 60 | Not Ready — Significant rework needed |
