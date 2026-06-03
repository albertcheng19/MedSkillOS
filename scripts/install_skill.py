import argparse
import json
import shutil
from pathlib import Path


def load_index(dist_dir: Path, target: str):
    index_path = dist_dir / f"{target}-index.json"
    if not index_path.exists():
        raise FileNotFoundError(f"Missing index: {index_path}")
    return json.loads(index_path.read_text(encoding="utf-8"))


def find_skill(index_items, skill_id: str):
    for item in index_items:
        if item.get("id") == skill_id:
            return item
    return None


def install_from_folder(skill_folder: Path, install_dir: Path, force: bool):
    if not skill_folder.exists():
        raise FileNotFoundError(f"Skill folder not found: {skill_folder}")
    dst = install_dir / skill_folder.name
    if dst.exists():
        if not force:
            raise FileExistsError(f"Destination exists: {dst} (use --force)")
        shutil.rmtree(dst)
    shutil.copytree(skill_folder, dst)
    return dst


def install_from_zip(zip_path: Path, install_dir: Path, force: bool):
    import zipfile

    if not zip_path.exists():
        raise FileNotFoundError(f"Skill archive not found: {zip_path}")
    with zipfile.ZipFile(zip_path, "r") as zf:
        top_levels = {Path(name).parts[0] for name in zf.namelist() if name.strip()}
        if len(top_levels) != 1:
            raise ValueError("Archive must contain exactly one top-level skill folder")
        skill_id = list(top_levels)[0]
        dst = install_dir / skill_id
        if dst.exists():
            if not force:
                raise FileExistsError(f"Destination exists: {dst} (use --force)")
            shutil.rmtree(dst)
        zf.extractall(install_dir)
    return dst


def main():
    parser = argparse.ArgumentParser(description="Install MedSkillOS exported skills offline.")
    parser.add_argument("--target", required=True, choices=["openclaw", "codex"])
    parser.add_argument("--skill", required=True, help="Skill id, e.g. dx-red-flag-detector")
    parser.add_argument("--install-dir", required=True, help="Where to install the skill folder")
    parser.add_argument("--dist-dir", default="dist", help="Path to dist directory")
    parser.add_argument("--source", choices=["folder", "zip"], default="folder")
    parser.add_argument("--force", action="store_true", help="Replace existing installed skill")
    args = parser.parse_args()

    dist_dir = Path(args.dist_dir).resolve()
    install_dir = Path(args.install_dir).resolve()
    install_dir.mkdir(parents=True, exist_ok=True)

    index_items = load_index(dist_dir, args.target)
    skill_item = find_skill(index_items, args.skill)
    if not skill_item:
        raise SystemExit(f"Skill not found in {args.target} index: {args.skill}")

    if args.source == "folder":
        skill_folder = dist_dir / args.target / args.skill
        installed = install_from_folder(skill_folder, install_dir, args.force)
    else:
        zip_path = dist_dir / args.target / f"{args.skill}.zip"
        installed = install_from_zip(zip_path, install_dir, args.force)

    print(f"OK: installed {args.skill} to {installed}")


if __name__ == "__main__":
    main()
