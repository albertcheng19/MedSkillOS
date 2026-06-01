---
name: dx-red-flag-detector
summary: Detect urgent red flags, escalation needs, and missing safety-critical information from a clinical case while preserving uncertainty and human review.
---

## When to use

Use for structured red-flag screening in clinician-reviewed diagnostic reasoning workflows.

## Optional script

- `python scripts/run.py --input <input.json> --output <output.json>`

## Safety rules

- Do not output final diagnosis.
- Do not output treatment, medication, or dosing instructions.
- Keep human review required.
- Use emergency-seeking wording when urgent risk patterns are present.
