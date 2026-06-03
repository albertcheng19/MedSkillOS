#!/bin/bash
# LitBase — Optional manual setup script
#
# You do NOT need to run this script manually.
# Simply open this folder in Claude Code and type /setup —
# the setup command will configure everything automatically.
#
# This script is provided for advanced users who prefer
# to set up the symlinks and permissions manually.
set -e

echo "LitBase setup..."
echo ""

# 1. Create .claude/ directory
mkdir -p ".claude"

# 2. Symlink .claude/commands -> commands/ (editable directly)
if [ -L ".claude/commands" ] || [ -d ".claude/commands" ]; then
  echo "  .claude/commands already exists"
else
  ln -s "../commands" ".claude/commands"
  echo "  created .claude/commands symlink"
fi

# 3. Symlink memory -> Claude Code project memory directory
PROJECT_PATH=$(pwd)
ENCODED_PATH=$(echo "$PROJECT_PATH" | sed 's|/|-|g')
MEMORY_DIR="$HOME/.claude/projects/$ENCODED_PATH/memory"
mkdir -p "$MEMORY_DIR"

if [ -L "memory" ]; then
  echo "  memory symlink already exists"
else
  # If memory/ is a real directory (template on first install), copy files then replace with symlink
  if [ -d "memory" ]; then
    cp -n memory/* "$MEMORY_DIR/" 2>/dev/null || true
    rm -rf "memory"
  fi
  ln -s "$MEMORY_DIR" "memory"
  echo "  created memory symlink"
fi

# 4. Copy permissions config (do not overwrite existing)
if [ -f ".claude/settings.local.json" ]; then
  echo "  .claude/settings.local.json already exists"
else
  cp "settings.local.json" ".claude/settings.local.json"
  echo "  copied settings.local.json"
fi

echo ""
echo "Done. Next steps:"
echo "  1. Edit config.json and set your data_dir path"
echo "  2. Open this folder in Claude Code and type /setup to begin"
