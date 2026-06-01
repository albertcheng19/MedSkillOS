---
name: dx-red-flag-detector
summary: Detect urgent red flags and missing safety-critical details from clinical case input for clinician-reviewed workflows.
---

## Purpose

Provide deterministic, safety-aware red flag extraction with explicit uncertainty and role-specific next steps.

## Codex execution notes

- Run scripts directly:
  - `python scripts/run.py --input <input.json> --output <output.json>`
  - `python scripts/validate_output.py <output.json>`
  - `python scripts/self_test.py`

## Constraints

- Never produce final diagnosis.
- Never produce treatment or dosing advice.
- Keep `human_review_required: true`.
