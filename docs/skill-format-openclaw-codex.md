# MedSkillOS Skill Format: OpenClaw + Codex

MedSkillOS uses a canonical, medical-contract-first format and supports export views for OpenClaw and Codex environments.

## Canonical folder structure

```text
SKILL.md
medskill.yaml
README.md
risk.md
schemas/input.schema.json
schemas/output.schema.json
knowledge/*.yaml
scripts/run.py
scripts/validate_output.py
scripts/self_test.py
tests/fixtures/*.json
tests/expected/*.json
adapters/openclaw/SKILL.md
adapters/codex/AGENTS.md
adapters/codex/SKILL.md
```

## OpenClaw export view

OpenClaw exports use a portable folder with:

- `SKILL.md`
- `risk.md`
- `schemas/`
- `knowledge/`
- `scripts/`

## Codex export view

Codex exports include operational and maintenance context:

- `AGENTS.md`
- `SKILL.md`
- `medskill.yaml`
- `README.md`
- `risk.md`
- `schemas/`
- `knowledge/`
- `scripts/`
- `tests/`

## Safety design

- no hidden shell execution
- no network by default
- explicit permissions in `medskill.yaml`
- no medical final diagnosis
- no treatment or medication dosing

## Why `medskill.yaml` is canonical

`medskill.yaml` is the machine-readable contract used by tooling, validation, CI, and runtime gates. It standardizes risk level, permissions, intended/non-intended use, required outputs, and review roles across environments. `SKILL.md` is human guidance; `medskill.yaml` is enforceable policy.
