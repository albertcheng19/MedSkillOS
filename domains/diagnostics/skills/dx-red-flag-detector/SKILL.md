---
name: dx-red-flag-detector
description: Use when an AI agent must identify urgent clinical red flags, cannot-miss conditions, escalation needs, and missing safety-critical information from a clinical presentation. This skill supports clinician-reviewed diagnostic reasoning and medical education. It must not provide autonomous diagnosis or treatment.
---

## When to use

- Triage-oriented case review where urgent warning signs might be present.
- Clinician-reviewed educational reasoning workflows.
- Structured extraction of missing safety-critical information.

## When not to use

- As an autonomous diagnostic decision-maker.
- For treatment planning, prescribing, or medication dosing.
- As a replacement for emergency services.

## Required behavior

- Identify red flags and cannot-miss conditions from available case facts.
- Mark uncertainty and missing information explicitly.
- Keep `human_review_required: true` for all outputs.
- Use role-specific next steps for clinician, nurse, and patient communication.

## Output contract

The output must conform to `schemas/output.schema.json` and include:

- `urgency_level`
- `red_flags`
- `cannot_miss_conditions`
- `missing_information`
- `role_specific_next_steps`
- `limitations`
- `human_review_required`

## Optional script usage

- `python scripts/run.py --input <input.json> --output <output.json>`
- `python scripts/validate_output.py <output.json>`
- `python scripts/self_test.py`

## Safety constraints

- No final diagnosis.
- No treatment or drug dosing.
- No hidden shell or network actions.
- Output is for clinician-reviewed workflow support only.
