#!/usr/bin/env bash
# Install skills into OpenClaw from a GitHub repo
# One-liner usage:
#   bash <(curl -s https://raw.githubusercontent.com/aipoch/medical-research-skills/main/scripts/openclaw-install.sh)

set -euo pipefail

REPO_URL="https://github.com/aipoch/medical-research-skills"

SKILLS_DIR="${OPENCLAW_SKILLS_DIR:-${HOME}/.openclaw/skills}"

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "⬇️  Cloning ${REPO_URL} ..."
git clone --depth=1 "$REPO_URL" "$TMP_DIR/repo" 2>/dev/null
echo "✅ Clone complete."
echo ""

installed=0
skipped=0

while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"
  target="${SKILLS_DIR}/${skill_name}"

  if [[ -e "$target" ]]; then
    echo "  ⏭  skipped (already exists): $skill_name"
    skipped=$((skipped + 1))
    continue
  fi

  if $DRY_RUN; then
    echo "  [dry-run] would install: $skill_name"
  else
    mkdir -p "$SKILLS_DIR"
    cp -r "$skill_dir" "$target"   
    echo "  ✅ installed: $skill_name"
  fi
  installed=$((installed + 1))
done < <(find "$TMP_DIR/repo" -name "SKILL.md" -not -path "*/.git/*")

echo ""
if $DRY_RUN; then
  echo "Dry run complete. Would install ${installed} skill(s). (${skipped} already exist)"
else
  echo "Done. Installed ${installed} skill(s). (${skipped} already existed)"
  echo "👉  Run: openclaw gateway restart"
fi
