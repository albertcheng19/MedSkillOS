#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Skill Evaluator — structural pre-check and metadata extraction script.
Handles Steps 1–3 (veto, static scoring prep, classification + execution mode detection).
Steps 4–8 are performed by Claude directly using SKILL.md instructions.
"""

import argparse
import json
import os
import re

# ─────────────────────────────────────────────
# Step 1: Basic Veto
# ─────────────────────────────────────────────

def run_basic_veto(skill_path):
    """
    Structural pass/fail checks on the skill directory.
    Returns dict of dimension -> PASS/FAIL with reasons.
    """
    results = {}
    skill_md_path = os.path.join(skill_path, "SKILL.md")
    scripts_path = os.path.join(skill_path, "scripts")

    # T1: Operational Stability — check SKILL.md exists, scripts are valid Python
    t1_issues = []
    if not os.path.isfile(skill_md_path):
        t1_issues.append("Missing SKILL.md")
    if os.path.isdir(scripts_path):
        for fname in os.listdir(scripts_path):
            if fname.endswith(".py") and fname != "evaluate_skill.py":
                fpath = os.path.join(scripts_path, fname)
                try:
                    with open(fpath, "r") as f:
                        source = f.read()
                    compile(source, fpath, "exec")
                except SyntaxError as e:
                    t1_issues.append(f"Syntax error in {fname}: {e}")
    results["T1. Stability"] = "FAIL: " + "; ".join(t1_issues) if t1_issues else "PASS"

    # T2: Structural Consistency — check YAML frontmatter has required fields
    t2_issues = []
    if os.path.isfile(skill_md_path):
        with open(skill_md_path, "r") as f:
            content = f.read()
        if not content.startswith("---"):
            t2_issues.append("Missing YAML frontmatter")
        else:
            fm = content.split("---")[1] if "---" in content else ""
            for field in ["name", "description"]:
                if field + ":" not in fm:
                    t2_issues.append(f"Missing required frontmatter field: '{field}'")
    results["T2. Contract"] = "FAIL: " + "; ".join(t2_issues) if t2_issues else "PASS"

    # T3: Result Determinism — check for obvious sources of non-determinism in scripts
    t3_issues = []
    if os.path.isdir(scripts_path):
        for fname in os.listdir(scripts_path):
            if fname.endswith(".py"):
                fpath = os.path.join(scripts_path, fname)
                with open(fpath, "r") as f:
                    source = f.read()
                if "random.random()" in source and "seed" not in source:
                    t3_issues.append(f"{fname}: uses random without seed")
                if re.search(r"while\s+True", source) and "break" not in source:
                    t3_issues.append(f"{fname}: potential infinite loop (while True with no break)")
    results["T3. Determinism"] = "FAIL: " + "; ".join(t3_issues) if t3_issues else "PASS"

    # T4: System Security — check for dangerous patterns in scripts
    t4_issues = []
    # Patterns encoded to avoid self-detection when this file is scanned
    dangerous_patterns = [
        (r"\b" + "eval" + r"\s*\(", "use of eval()"),
        (r"\b" + "exec" + r"\s*\(", "use of exec()"),
        ("os." + r"system\s*\(", "use of os.system()"),
        ("subprocess.*" + "shell" + r"\s*=\s*True", "subprocess with shell=True"),
    ]
    if os.path.isdir(scripts_path):
        for fname in os.listdir(scripts_path):
            if fname.endswith(".py") and fname != "evaluate_skill.py":
                fpath = os.path.join(scripts_path, fname)
                with open(fpath, "r") as f:
                    source = f.read()
                for pattern, label in dangerous_patterns:
                    if re.search(pattern, source):
                        t4_issues.append(f"{fname}: {label}")
    results["T4. Security"] = "FAIL: " + "; ".join(t4_issues) if t4_issues else "PASS"

    return results


# ─────────────────────────────────────────────
# Step 2: Static Metadata for Basic Evaluation
# ─────────────────────────────────────────────

def extract_static_metadata(skill_path):
    """Extract metadata to assist Claude's static quality scoring."""
    skill_md_path = os.path.join(skill_path, "SKILL.md")
    if not os.path.isfile(skill_md_path):
        return {"error": "SKILL.md not found"}

    with open(skill_md_path, "r") as f:
        content = f.read()

    # Parse frontmatter
    fm = {}
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) >= 3:
            for line in parts[1].strip().splitlines():
                if ":" in line:
                    k, _, v = line.partition(":")
                    fm[k.strip()] = v.strip()

    # Count reference files
    ref_dir = os.path.join(skill_path, "references")
    ref_count = len(os.listdir(ref_dir)) if os.path.isdir(ref_dir) else 0

    # Count scripts
    scripts_dir = os.path.join(skill_path, "scripts")
    script_count = len([f for f in os.listdir(scripts_dir) if f.endswith(".py")]) if os.path.isdir(scripts_dir) else 0

    # Detect section headers in SKILL.md body
    headers = re.findall(r"^#{1,3} (.+)$", content, re.MULTILINE)

    # Check for workflow indicators
    has_code_blocks = "```" in content
    has_when_to_use = any("when to use" in h.lower() for h in headers)
    has_workflow = any("workflow" in h.lower() or "step" in h.lower() for h in headers)
    skill_md_lines = len(content.splitlines())

    return {
        "name": fm.get("name", "unknown"),
        "description": fm.get("description", ""),
        "description_word_count": len(fm.get("description", "").split()),
        "skill_md_lines": skill_md_lines,
        "reference_files": ref_count,
        "script_files": script_count,
        "section_headers": headers,
        "has_code_blocks": has_code_blocks,
        "has_when_to_use_section": has_when_to_use,
        "has_workflow_section": has_workflow,
    }


# ─────────────────────────────────────────────
# Step 3: Classification + Execution Mode
# ─────────────────────────────────────────────

def classify_skill(skill_path):
    """
    Classify skill into one of 5 canonical categories:
      1. Evidence Insight
      2. Protocol Design
      3. Data Analysis
      4. Academic Writing
      5. Other (General / Non-Research)
    Also detect execution mode: A (Claude), B (CLI), C (API), D (Hybrid).
    """
    skill_md_path = os.path.join(skill_path, "SKILL.md")
    if not os.path.isfile(skill_md_path):
        return {"category": "Unknown", "execution_mode": "Unknown"}

    with open(skill_md_path, "r") as f:
        content = f.read().lower()

    # Category classification — keyword sets per canonical category
    evidence_insight_keywords = ["search strategy", "literature search", "evidence level",
                                  "critical appraisal", "evidence synthesis", "database selection",
                                  "research gap", "systematic search"]
    protocol_design_keywords = ["experimental design", "study design", "statistical power",
                                 "sample size", "validation strategy", "causal inference",
                                 "clinical trial", "study protocol"]
    data_analysis_keywords = ["data analysis", "statistical", "r script", "python analysis",
                               "regression", "bioinformatics", "data cleaning", "machine learning",
                               "visualization", "pipeline"]
    academic_writing_keywords = ["meta-analysis", "literature review", "academic writing",
                                  "cover letter", "manuscript", "abstract generation",
                                  "methods writing", "results writing", "discussion writing",
                                  "sci paper"]

    scores = {
        "Evidence Insight": sum(1 for kw in evidence_insight_keywords if kw in content),
        "Protocol Design": sum(1 for kw in protocol_design_keywords if kw in content),
        "Data Analysis": sum(1 for kw in data_analysis_keywords if kw in content),
        "Academic Writing": sum(1 for kw in academic_writing_keywords if kw in content),
    }

    max_score = max(scores.values())
    if max_score == 0:
        category = "Other"
    else:
        # Tie-break by canonical category order (1 → 2 → 3 → 4)
        category = next(c for c in ["Evidence Insight", "Protocol Design",
                                     "Data Analysis", "Academic Writing"]
                        if scores[c] == max_score)

    # Execution mode detection
    scripts_dir = os.path.join(skill_path, "scripts")
    has_scripts = os.path.isdir(scripts_dir) and any(
        f.endswith(".py") or f.endswith(".sh") for f in os.listdir(scripts_dir)
    )
    has_api_patterns = any(kw in content for kw in ["fetch(", "requests.get", "curl", "api endpoint", "http"])
    has_cli_examples = bool(re.search(r"```(?:bash|sh)\n.*python", content))

    if has_scripts and has_api_patterns:
        execution_mode = "D (Hybrid)"
    elif has_scripts or has_cli_examples:
        execution_mode = "B (CLI/Script)"
    elif has_api_patterns:
        execution_mode = "C (API)"
    else:
        execution_mode = "A (Claude Direct)"

    return {
        "category": category,
        "execution_mode": execution_mode,
        "category_keyword_scores": scores,
    }


# ─────────────────────────────────────────────
# Complexity Assessment (used in Step 4)
# ─────────────────────────────────────────────

def assess_complexity(metadata, classification):
    """
    Estimate skill complexity to determine how many test inputs to generate.
    Returns: Simple (3), Moderate (5), or Complex (7)
    """
    score = 0

    # Reference files
    ref_count = metadata.get("reference_files", 0)
    if ref_count >= 5:
        score += 2
    elif ref_count >= 3:
        score += 1

    # SKILL.md length
    lines = metadata.get("skill_md_lines", 0)
    if lines >= 200:
        score += 2
    elif lines >= 100:
        score += 1

    # Script files
    if metadata.get("script_files", 0) > 0:
        score += 1

    # Research category (inherently more complex rubric)
    if classification.get("category") != "Other":
        score += 1

    # Description length
    if metadata.get("description_word_count", 0) >= 50:
        score += 1

    if score >= 5:
        return {"level": "Complex", "n_inputs": 7}
    elif score >= 2:
        return {"level": "Moderate", "n_inputs": 5}
    else:
        return {"level": "Simple", "n_inputs": 3}


# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────

def run_structural_precheck(skill_path):
    """
    Run all structural checks (Steps 1–3) and return a JSON report.
    This report is passed to Claude to inform Steps 4–8.
    """
    report = {}

    # Step 1
    veto = run_basic_veto(skill_path)
    report["step1_basic_veto"] = veto

    any_veto_fail = any("FAIL" in str(v) for v in veto.values())
    if any_veto_fail:
        report["gate_result"] = "REJECTED at Step 1"
        report["next_action"] = "Stop evaluation. Fix veto failures before resubmitting."
        return report

    report["gate_result"] = "PASSED Step 1 — proceed to Steps 2–8"

    # Step 2 metadata
    metadata = extract_static_metadata(skill_path)
    report["step2_static_metadata"] = metadata

    # Step 3
    classification = classify_skill(skill_path)
    report["step3_classification"] = classification

    # Complexity
    complexity = assess_complexity(metadata, classification)
    report["step4_complexity"] = complexity

    report["instructions_for_claude"] = (
        f"Structural pre-check complete. Proceed with Steps 2–8 using SKILL.md instructions.\n"
        f"  Category: {classification['category']}\n"
        f"  Execution Mode: {classification['execution_mode']}\n"
        f"  Complexity: {complexity['level']} → Generate {complexity['n_inputs']} test inputs in Step 4."
    )

    return report


def main():
    parser = argparse.ArgumentParser(
        description="Skill Evaluator — structural pre-check (Steps 1-3). Steps 4-8 run via Claude."
    )
    parser.add_argument("skill_path", type=str, help="Path to the skill directory")
    parser.add_argument("--json-only", action="store_true", help="Output raw JSON only")
    args = parser.parse_args()

    if not os.path.isdir(args.skill_path):
        print(json.dumps({"error": f"Skill path not found: '{args.skill_path}'"}))
        return

    report = run_structural_precheck(args.skill_path)

    if args.json_only:
        print(json.dumps(report, indent=2))
    else:
        print(json.dumps(report, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
