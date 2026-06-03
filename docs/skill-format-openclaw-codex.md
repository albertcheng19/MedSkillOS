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

## Extensible packaging workflow

MedSkillOS packaging is auto-discovery based:

- Any folder under `domains/*/skills/*` with `medskill.yaml` is treated as a buildable skill.
- `python scripts/build_skill_exports.py` automatically exports all discovered skills for OpenClaw and Codex.
- Build output includes:
  - per-target folders (`dist/openclaw/<skill_id>/`, `dist/codex/<skill_id>/`)
  - per-skill archives (`dist/openclaw/<skill_id>.zip`, `dist/codex/<skill_id>.zip`)
  - target indexes (`dist/openclaw-index.json`, `dist/codex-index.json`)
  - global catalog (`dist/catalog.json`)

This means adding new skills does not require editing the export script.

## Offline install workflow

After build, skills can be installed from dist artifacts:

```bash
python scripts/install_skill.py --target openclaw --skill dx-red-flag-detector --install-dir /tmp/openclaw-skills
python scripts/install_skill.py --target codex --skill dx-red-flag-detector --install-dir /tmp/codex-skills
```
