import argparse
import json
from pathlib import Path

FALLBACK_RULES = [
    {
        "id": "chest_pain_instability",
        "trigger_keywords": [
            "chest pain",
            "diaphoresis",
            "syncope",
            "hypotension",
            "dyspnea",
            "shortness of breath",
            "neurologic deficit",
        ],
        "concern": "Potential cardiopulmonary or vascular emergency pattern.",
        "missing_info_to_check": [
            "blood pressure",
            "heart rate",
            "oxygen saturation",
            "ECG status",
            "neurologic exam",
        ],
        "cannot_miss": [
            "acute coronary syndrome",
            "aortic dissection",
            "pulmonary embolism",
        ],
    },
    {
        "id": "headache_critical_pattern",
        "trigger_keywords": [
            "sudden headache",
            "worst headache",
            "thunderclap",
            "neurologic deficit",
            "fever",
            "neck stiffness",
            "postpartum",
            "pregnancy",
            "immunosuppression",
        ],
        "concern": "Potential intracranial, infectious, or vascular emergency pattern.",
        "missing_info_to_check": [
            "neurologic exam",
            "temperature trend",
            "blood pressure",
            "pregnancy/postpartum status",
            "immune status",
        ],
        "cannot_miss": [
            "subarachnoid hemorrhage",
            "meningitis",
            "cerebral venous thrombosis",
        ],
    },
    {
        "id": "abdominal_pain_high_risk",
        "trigger_keywords": [
            "abdominal pain",
            "lower abdominal pain",
            "pregnancy possible",
            "peritonitis",
            "rebound",
            "guarding",
            "hypotension",
            "gi bleeding",
            "persistent severe pain",
        ],
        "concern": "Potential surgical, hemorrhagic, or pregnancy-related emergency pattern.",
        "missing_info_to_check": [
            "pregnancy test status",
            "blood pressure",
            "heart rate",
            "bleeding amount",
            "peritoneal signs",
        ],
        "cannot_miss": ["ectopic pregnancy", "appendicitis", "bowel perforation"],
    },
    {
        "id": "fever_systemic_instability",
        "trigger_keywords": [
            "fever",
            "altered mental status",
            "hypotension",
            "dyspnea",
            "purpura",
            "rash",
            "immunosuppression",
        ],
        "concern": "Potential severe infection or systemic instability.",
        "missing_info_to_check": [
            "blood pressure",
            "respiratory status",
            "mental status trend",
            "immune status",
        ],
        "cannot_miss": ["sepsis", "meningococcemia", "severe pneumonia"],
    },
    {
        "id": "dyspnea_critical_pattern",
        "trigger_keywords": [
            "dyspnea",
            "hypoxia",
            "chest pain",
            "cyanosis",
            "altered mental status",
        ],
        "concern": "Potential respiratory or circulatory failure pattern.",
        "missing_info_to_check": [
            "oxygen saturation",
            "respiratory rate",
            "chest pain character",
            "mental status",
        ],
        "cannot_miss": ["pulmonary embolism", "pneumothorax", "acute heart failure"],
    },
]


def normalize_case_text(data):
    chunks = []

    def walk(value):
        if isinstance(value, dict):
            for v in value.values():
                walk(v)
        elif isinstance(value, list):
            for v in value:
                walk(v)
        elif isinstance(value, (str, int, float, bool)):
            chunks.append(str(value).lower())

    walk(data)
    return " ".join(chunks)


def load_rules(rule_path):
    # Deterministic and dependency-free prototype: keep fallback rules in Python.
    if rule_path.exists():
        _ = rule_path.read_text(encoding="utf-8")
    return FALLBACK_RULES


def run(input_path, output_path):
    with open(input_path, "r", encoding="utf-8") as f:
        case_data = json.load(f)

    combined = normalize_case_text(case_data)
    rules = load_rules(Path(__file__).resolve().parents[1] / "knowledge" / "red_flags.yaml")

    matched_flags = []
    cannot_miss = []
    missing_info = []

    for rule in rules:
        if any(kw in combined for kw in rule["trigger_keywords"]):
            matched_flags.append(f"{rule['id']}: {rule['concern']}")
            cannot_miss.extend(rule.get("cannot_miss", []))
            missing_info.extend(rule.get("missing_info_to_check", []))

    if not case_data.get("history", {}).get("vitals"):
        missing_info.extend(
            [
                "blood pressure",
                "heart rate",
                "respiratory rate",
                "oxygen saturation",
                "temperature",
            ]
        )

    urgency = "emergency_or_urgent" if matched_flags else "routine_or_uncertain"

    output = {
        "object_type": "DiagnosticReasoningObject",
        "status": "ok",
        "urgency_level": urgency,
        "red_flags": sorted(set(matched_flags)),
        "cannot_miss_conditions": sorted(set(cannot_miss)),
        "missing_information": sorted(set(missing_info)),
        "role_specific_next_steps": {
            "clinician": [
                "Review urgency drivers, verify missing critical data, and perform clinician-level assessment.",
                "Use findings to prioritize immediate evaluation pathway.",
            ],
            "nurse": [
                "Prioritize observation, vital sign acquisition, and concise handoff of warning signs.",
                "Escalate to supervising clinician based on deterioration signals.",
            ],
            "patient": [
                "Seek prompt professional medical evaluation.",
                "If severe worsening symptoms are present, seek emergency care immediately.",
            ],
        },
        "limitations": [
            "Rule-based prototype with limited pattern coverage.",
            "Not a diagnostic authority and not a treatment tool.",
            "Findings require clinician and triage reviewer confirmation.",
        ],
        "human_review_required": True,
    }

    out_path = Path(output_path)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(output, f, indent=2)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    run(args.input, args.output)


if __name__ == "__main__":
    main()
