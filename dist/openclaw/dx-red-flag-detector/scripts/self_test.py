import json
import subprocess
import sys
from pathlib import Path

SKILL_ROOT = Path(__file__).resolve().parents[1]
FIXTURES = SKILL_ROOT / "tests" / "fixtures"
EXPECTED = SKILL_ROOT / "tests" / "expected" / "chest_pain_high_risk.output.json"
TMP_OUT = SKILL_ROOT / "tests" / "tmp"


def run_cmd(cmd):
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(result.stdout)
        print(result.stderr)
        raise RuntimeError(f"Command failed: {' '.join(cmd)}")


def main():
    TMP_OUT.mkdir(parents=True, exist_ok=True)

    for fixture in sorted(FIXTURES.glob("*.json")):
        out = TMP_OUT / fixture.name.replace(".input.json", ".output.json")
        run_cmd(
            [
                sys.executable,
                str(SKILL_ROOT / "scripts" / "run.py"),
                "--input",
                str(fixture),
                "--output",
                str(out),
            ]
        )
        run_cmd([sys.executable, str(SKILL_ROOT / "scripts" / "validate_output.py"), str(out)])

    with open(TMP_OUT / "chest_pain_high_risk.output.json", "r", encoding="utf-8") as f:
        actual = json.load(f)
    with open(EXPECTED, "r", encoding="utf-8") as f:
        _expected = json.load(f)

    if not actual.get("red_flags"):
        raise RuntimeError("Expected at least one red flag for chest pain case")
    if actual.get("urgency_level") != "emergency_or_urgent":
        raise RuntimeError("Expected urgency_level emergency_or_urgent for chest pain case")

    cannot_miss = {x.lower() for x in actual.get("cannot_miss_conditions", [])}
    required_any = {"acute coronary syndrome", "aortic dissection", "pulmonary embolism"}
    if not cannot_miss.intersection(required_any):
        raise RuntimeError("Expected ACS or aortic dissection or pulmonary embolism in cannot_miss_conditions")

    for p in TMP_OUT.glob("*.json"):
        p.unlink(missing_ok=True)
    TMP_OUT.rmdir()

    print("OK: self-test passed")


if __name__ == "__main__":
    main()
