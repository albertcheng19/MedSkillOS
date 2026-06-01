# MedSkillOS

**Medical-grade agent skills for clinical and biomedical workflows.**

MedSkillOS is an open, agent-native skill operating system for medicine and biomedical science. It provides lightweight domain skills, execution harnesses, evidence objects, quality-control standards, provenance tracking, and expert-reviewed self-refinement loops for AI agents.

MedSkillOS is **not** a medical chatbot, a medical knowledge dump, or an autonomous diagnostic system. It is a medical standards layer that helps AI agents use medical knowledge, tools, databases, and workflows according to clinical and scientific standards.

## Why MedSkillOS?

Medical AI tools are growing quickly. We already have biomedical MCP servers, clinical RAG systems, medical image tools, wearable-data agents, research assistants, and large skill collections.

But most existing tools focus on access:

- Access to PubMed, NCBI, FHIR, OMOP, DICOM, clinical trials, or wearable data
- Access to guideline documents or medical databases
- Access to single-task scripts or domain-specific utilities

MedSkillOS focuses on assurance:

- Was the right skill selected?
- Was the input valid?
- Were medical safety gates applied?
- Was the output evidence-aware?
- Were uncertainty and limitations reported?
- Was provenance recorded?
- Was quality control performed?
- Can clinicians, nurses, researchers, or patients review the result?
- Can failures become reviewed improvements instead of hidden errors?

## What MedSkillOS Provides

MedSkillOS has four core layers.

### 1. Domain Skill Packs

Each medical domain is organized as a domain pack. A domain pack contains agent-readable skills, executable wrappers, schemas, examples, evaluation cases, risk policies, and reviewer guidance.

Initial domain packs:

- `diagnostics` — structured clinical reasoning, differential diagnosis, red-flag detection, evidence mapping, and role-specific communication
- `clinical-neuroscience` — EEG, MEG, fMRI, source localization, spectral analysis, connectivity analysis, and neurophysiology reporting

Planned domain packs:

- `radiology`
- `pathology`
- `laboratory-medicine`
- `pharmacology`
- `genomics`
- `nursing`
- `emergency-critical-care`
- `public-health`
- `rehabilitation`
- `medical-education`
- `medical-device-compliance`

### 2. Medical Skill Harness

The harness runs, validates, audits, and evaluates skills.

It checks:

- input and output schemas
- parameter sanity
- safety boundaries
- evidence requirements
- quality-control artifacts
- provenance metadata
- deterministic tests
- regression evaluations
- human-review requirements

The goal is not just to run skills, but to make medical-agent workflows reproducible, reviewable, and improvable.

### 3. Evidence and Provenance Objects

MedSkillOS standardizes how agents represent evidence, data-processing outputs, and clinical reasoning artifacts.

Core objects include:

- `ClinicalQuestion`
- `EvidenceObject`
- `SkillRunTrace`
- `ClinicalExperienceRecord`
- `ReviewDecision`

These objects allow different domain packs to communicate without collapsing into unstructured text.

### 4. Expert-Reviewed Self-Refinement

MedSkillOS supports self-refining skills, but never through uncontrolled automatic clinical rule changes.

Failures, reviewer comments, and doctor/nurse/patient feedback are converted into structured experience records. Proposed improvements must pass validation, tests, and expert review before promotion.

Skill maturity states:

- `draft`
- `candidate`
- `experimental`
- `reviewed`
- `stable`
- `deprecated`

## What MedSkillOS Is Not

MedSkillOS is not:

- a replacement for clinicians
- a diagnostic authority
- a treatment recommendation engine
- a scraped medical textbook
- a guideline PDF mirror
- a general medical chatbot
- a marketplace of unverified tools

MedSkillOS is designed for research, education, clinical workflow support, biomedical data processing, and expert-reviewed agent development.

## Example Domain: Diagnostics

The diagnostics domain focuses on medical reasoning standards rather than disease encyclopedias.

Example skills:

- `problem-representation`
- `red-flag-detection`
- `differential-diagnosis-builder`
- `evidence-for-against-mapper`
- `missing-information-identifier`
- `source-router`
- `evidence-grader`
- `doctor-summary`
- `nurse-handoff`
- `patient-explanation`
- `feedback-classifier`
- `reviewer-gate`

The goal is to help agents reason in a clinically structured, evidence-aware, uncertainty-aware, and human-reviewable way.

## Example Domain: Clinical Neuroscience

The clinical-neuroscience domain focuses on reproducible neurodata workflows.

Example skills:

- `validate-bids-dataset`
- `load-eeg-meg-raw`
- `inspect-raw-quality`
- `apply-notch-filter`
- `apply-bandpass-filter`
- `detect-bad-channels`
- `fit-ica-or-ssp`
- `generate-eeg-meg-qc-report`
- `run-fmriprep-wrapper`
- `inspect-fmriprep-outputs`
- `compute-psd`
- `compute-time-frequency`
- `run-source-localization`
- `compute-connectivity`
- `generate-neuro-report`

The goal is to make EEG, MEG, fMRI, source localization, spectral analysis, and connectivity analysis accessible to agents while preserving QC, provenance, and scientific limitations.

## Skill Structure

Each skill follows a standard structure:

```text
skill-name/
  SKILL.md
  skill.yaml
  runner.py
  schemas/
    input.schema.json
    output.schema.json
  tests/
  evals/
  examples/
  memory/
  risk.md
  README.md
```

A skill must define:

- what it does
- when to use it
- when not to use it
- required inputs
- expected outputs
- safety boundaries
- evidence requirements
- quality-control requirements
- provenance requirements
- known failure modes

## Copyright and Source Policy

MedSkillOS is knowledge-light and standard-heavy.

We do not copy copyrighted textbooks, proprietary guideline content, paywalled clinical summaries, or restricted medical web pages into skills.

Instead, MedSkillOS stores:

- original workflow standards
- source-routing rules
- evidence-grading criteria
- schemas
- safety gates
- quality-control checks
- review procedures
- de-identified experience records
- links and citations to allowed sources

Each source adapter must declare licensing, caching, citation, and usage constraints.

## Contributing

MedSkillOS welcomes contributors from multiple roles:

- physicians
- nurses
- pharmacists
- clinical neuroscientists
- radiologists
- pathologists
- genetic counselors
- biomedical researchers
- patients and caregivers
- software engineers
- evaluation designers
- safety and governance reviewers

You do not need to write code to contribute. Domain experts can contribute workflows, review criteria, failure cases, safety checks, evaluation cases, and feedback.

See [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

## Disclaimer

MedSkillOS is for research, education, workflow support, and expert-reviewed agent development. It is not a validated clinical tool and must not be used as a replacement for qualified medical judgment, diagnosis, or treatment.

Medical outputs generated using MedSkillOS require appropriate human review.
