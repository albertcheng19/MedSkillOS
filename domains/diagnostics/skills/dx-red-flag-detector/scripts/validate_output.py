import json
import re
import sys

REQUIRED = {
    "object_type",
    "status",
    "urgency_level",
    "red_flags",
    "cannot_miss_conditions",
    "missing_information",
    "role_specific_next_steps",
    "limitations",
    "human_review_required",
}

FORBIDDEN_PATTERNS = [
    r"final diagnosis",
    r"definitive diagnosis",
    r"take\s+[a-z]+",
    r"dosage",
    r"prescription",
]


def flatten_text(value):
    chunks = []
    if isinstance(value, dict):
        for v in value.values():
            chunks.extend(flatten_text(v))
    elif isinstance(value, list):
        for v in value:
            chunks.extend(flatten_text(v))
    elif isinstance(value, (str, int, float, bool)):
        chunks.append(str(value).lower())
    return chunks


def main():
    if len(sys.argv) != 2:
        print("FAIL: usage python scripts/validate_output.py <output.json>")
        sys.exit(1)

    with open(sys.argv[1], "r", encoding="utf-8") as f:
        data = json.load(f)

    missing = REQUIRED - data.keys()
    if missing:
        print(f"FAIL: missing required keys: {sorted(missing)}")
        sys.exit(1)

    if data.get("object_type") != "DiagnosticReasoningObject":
        print("FAIL: object_type must be DiagnosticReasoningObject")
        sys.exit(1)

    if data.get("human_review_required") is not True:
        print("FAIL: human_review_required must be true")
        sys.exit(1)

    text = " ".join(flatten_text(data))
    for pattern in FORBIDDEN_PATTERNS:
        if re.search(pattern, text):
            print(f"FAIL: forbidden phrase/pattern matched: {pattern}")
            sys.exit(1)

    print("OK: output is valid")


if __name__ == "__main__":
    main()
