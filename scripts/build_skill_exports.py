import shutil
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "domains" / "diagnostics" / "skills" / "dx-red-flag-detector"
DIST = ROOT / "dist"


def copy_tree(src: Path, dst: Path):
    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst)


def build_openclaw_export():
    dst = DIST / "openclaw" / "dx-red-flag-detector"
    if dst.exists():
        shutil.rmtree(dst)
    dst.mkdir(parents=True, exist_ok=True)

    shutil.copy2(SKILL / "adapters" / "openclaw" / "SKILL.md", dst / "SKILL.md")
    shutil.copy2(SKILL / "risk.md", dst / "risk.md")
    copy_tree(SKILL / "schemas", dst / "schemas")
    copy_tree(SKILL / "knowledge", dst / "knowledge")
    copy_tree(SKILL / "scripts", dst / "scripts")


def build_codex_export():
    dst = DIST / "codex" / "dx-red-flag-detector"
    if dst.exists():
        shutil.rmtree(dst)
    dst.mkdir(parents=True, exist_ok=True)

    shutil.copy2(SKILL / "adapters" / "codex" / "AGENTS.md", dst / "AGENTS.md")
    shutil.copy2(SKILL / "adapters" / "codex" / "SKILL.md", dst / "SKILL.md")
    shutil.copy2(SKILL / "medskill.yaml", dst / "medskill.yaml")
    shutil.copy2(SKILL / "README.md", dst / "README.md")
    shutil.copy2(SKILL / "risk.md", dst / "risk.md")
    copy_tree(SKILL / "schemas", dst / "schemas")
    copy_tree(SKILL / "knowledge", dst / "knowledge")
    copy_tree(SKILL / "scripts", dst / "scripts")
    copy_tree(SKILL / "tests", dst / "tests")


def make_zip(src_dir: Path, zip_path: Path):
    if zip_path.exists():
        zip_path.unlink()
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zf:
        for p in src_dir.rglob("*"):
            if p.is_file():
                zf.write(p, p.relative_to(src_dir.parent))


def main():
    DIST.mkdir(parents=True, exist_ok=True)
    build_openclaw_export()
    build_codex_export()
    make_zip(DIST / "openclaw", DIST / "MedSkillOS-diagnostics-openclaw.zip")
    make_zip(DIST / "codex", DIST / "MedSkillOS-diagnostics-codex.zip")
    print("OK: built skill exports")


if __name__ == "__main__":
    main()
