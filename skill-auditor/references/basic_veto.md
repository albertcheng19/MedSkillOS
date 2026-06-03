# Basic Veto Criteria

This section details the immediate rejection criteria for any Manus Skill. If a skill fails any of these tests, it will be rejected without further evaluation.

| **Core Redline (Risk Category & Item)** | **Immediate Rejection Criteria** | **Result** |
| --- | --- | --- |
| **T1. Operational Stability** | 1. Failure rate > 20% in 10 consecutive calls (Success Rate < 80%).<br>2. Presence of random crashes or logical infinite loops.<br>3. Unresolvable dependency conflicts requiring manual intervention. | **PASS / FAIL** |
| **T2. Structural Consistency (Contract)** | 1. Missing mandatory API fields, or non-compliant JSON format returned.<br>2. Inconsistent return types (e.g., String returned when Integer is required).<br>3. Inconsistent field names, not conforming to predefined Schema. | **PASS / FAIL** |
| **T3. Result Determinism** | 1. Significant output variance with identical input at low Temperature, leading to uncontrollable results.<br>2. Lack of Seed management mechanism, making experiments irreproducible.<br>3. Critical numerical results (e.g., statistical indicators) fluctuate randomly with each call. | **PASS / FAIL** |
| **T4. System Security** | 1. Allows direct execution of user-provided raw strings as code (injection risk).<br>2. Absence of input filtering mechanisms.<br>3. Presence of Prompt Injection risks, allowing unauthorized access or operations. | **PASS / FAIL** |

Any `FAIL` in this section will lead to immediate rejection of the skill.
