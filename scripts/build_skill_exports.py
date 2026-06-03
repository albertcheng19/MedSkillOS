import json
import shutil
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"
SKILLS_ROOT = ROOT / "domains"


def copy_tree(src: Path, dst: Path):
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)


def discover_skills():
    skills = []
    for medskill_path in SKILLS_ROOT.glob("*/skills/*/medskill.yaml"):
        skill_dir = medskill_path.parent
        try:
            skill_id = parse_id_from_medskill(medskill_path)
        except ValueError:
            skill_id = skill_dir.name
        domain = skill_dir.parents[2].name
        skills.append(
            {
                "id": skill_id,
                "domain": domain,
                "path": skill_dir,
            }
        )
    return sorted(skills, key=lambda x: (x["domain"], x["id"]))


def parse_id_from_medskill(path: Path):
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("id:"):
            return line.split(":", 1)[1].strip()
    raise ValueError(f"No id found in {path}")


def copy_if_exists(src: Path, dst: Path):
    if src.exists():
        if src.is_dir():
            copy_tree(src, dst)
        else:
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)


def export_openclaw(skill):
    src = skill["path"]
    out = DIST / "openclaw" / skill["id"]
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True, exist_ok=True)

    adapter_skill = src / "adapters" / "openclaw" / "SKILL.md"
    if adapter_skill.exists():
        shutil.copy2(adapter_skill, out / "SKILL.md")
    else:
        shutil.copy2(src / "SKILL.md", out / "SKILL.md")

    copy_if_exists(src / "risk.md", out / "risk.md")
    copy_if_exists(src / "schemas", out / "schemas")
    copy_if_exists(src / "knowledge", out / "knowledge")
    copy_if_exists(src / "scripts", out / "scripts")


def export_codex(skill):
    src = skill["path"]
    out = DIST / "codex" / skill["id"]
    if out.exists():
        shutil.rmtree(out)
    out.mkdir(parents=True, exist_ok=True)

    adapter_agents = src / "adapters" / "codex" / "AGENTS.md"
    adapter_skill = src / "adapters" / "codex" / "SKILL.md"
    if adapter_agents.exists():
        shutil.copy2(adapter_agents, out / "AGENTS.md")
    else:
        copy_if_exists(ROOT / "AGENTS.md", out / "AGENTS.md")
    if adapter_skill.exists():
        shutil.copy2(adapter_skill, out / "SKILL.md")
    else:
        shutil.copy2(src / "SKILL.md", out / "SKILL.md")

    copy_if_exists(src / "medskill.yaml", out / "medskill.yaml")
    copy_if_exists(src / "README.md", out / "README.md")
    copy_if_exists(src / "risk.md", out / "risk.md")
    copy_if_exists(src / "schemas", out / "schemas")
    copy_if_exists(src / "knowledge", out / "knowledge")
    copy_if_exists(src / "scripts", out / "scripts")
    copy_if_exists(src / "tests", out / "tests")


def make_zip(src_dir: Path, zip_path: Path):
    if zip_path.exists():
        zip_path.unlink()
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for p in src_dir.rglob("*"):
            if p.is_file():
                zf.write(p, p.relative_to(src_dir.parent))


def make_target_skill_zips(target_dir: Path):
    for skill_dir in sorted(p for p in target_dir.iterdir() if p.is_dir()):
        zip_path = target_dir / f"{skill_dir.name}.zip"
        if zip_path.exists():
            zip_path.unlink()
        with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
            for p in skill_dir.rglob("*"):
                if p.is_file():
                    zf.write(p, p.relative_to(target_dir))


def write_indexes(skills):
    catalog = {
        "format_version": "0.1.0",
        "generated_from": "scripts/build_skill_exports.py",
        "skills": [],
    }
    target_index = {"openclaw": [], "codex": []}

    for s in skills:
        base_item = {"id": s["id"], "domain": s["domain"]}
        catalog["skills"].append(base_item)

        target_index["openclaw"].append(
            {
                **base_item,
                "archive": f"dist/openclaw/{s['id']}.zip",
                "folder": f"dist/openclaw/{s['id']}",
            }
        )
        target_index["codex"].append(
            {
                **base_item,
                "archive": f"dist/codex/{s['id']}.zip",
                "folder": f"dist/codex/{s['id']}",
            }
        )

    (DIST / "catalog.json").write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    (DIST / "openclaw-index.json").write_text(
        json.dumps(target_index["openclaw"], ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    (DIST / "codex-index.json").write_text(
        json.dumps(target_index["codex"], ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def main():
    DIST.mkdir(parents=True, exist_ok=True)
    shutil.rmtree(DIST / "openclaw", ignore_errors=True)
    shutil.rmtree(DIST / "codex", ignore_errors=True)
    (DIST / "openclaw").mkdir(parents=True, exist_ok=True)
    (DIST / "codex").mkdir(parents=True, exist_ok=True)

    skills = discover_skills()
    if not skills:
        raise SystemExit("No skills discovered under domains/*/skills/*/medskill.yaml")

    for skill in skills:
        export_openclaw(skill)
        export_codex(skill)

    make_target_skill_zips(DIST / "openclaw")
    make_target_skill_zips(DIST / "codex")
    write_indexes(skills)

    (DIST / "MedSkillOS-diagnostics-openclaw.zip").unlink(missing_ok=True)
    (DIST / "MedSkillOS-diagnostics-codex.zip").unlink(missing_ok=True)
    print(f"OK: built exports for {len(skills)} skills")


if __name__ == "__main__":
    main()
