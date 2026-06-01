#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Install Ask DongFeng as a local Hermes skill.

Usage:
  scripts/install_hermes.sh [--check-only] [--dry-run]

Options:
  --check-only  Validate the package and show the target path without copying files.
  --dry-run     Show the copy operation without modifying the Hermes skill directory.

Environment:
  HERMES_HOME   Defaults to "$HOME/.hermes" when unset.
EOF
}

check_only=0
dry_run=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --check-only)
      check_only=1
      ;;
    --dry-run)
      dry_run=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
skill_home="${HERMES_HOME:-$HOME/.hermes}/skills/software-development/ask-dongfeng"

if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "Python is required to validate the skill package, but neither python3 nor python was found." >&2
  exit 1
fi

required_paths=(
  "$repo_root/SKILL.md"
  "$repo_root/references"
  "$repo_root/scripts"
  "$repo_root/agents"
)

for path in "${required_paths[@]}"; do
  if [ ! -e "$path" ]; then
    echo "Missing required path: $path" >&2
    exit 1
  fi
done

"$python_bin" "$repo_root/scripts/validate_skill.py" "$repo_root/SKILL.md"

echo "Ask DongFeng package is valid."
echo "Hermes target: $skill_home"

if [ "$check_only" -eq 1 ]; then
  exit 0
fi

if [ "$dry_run" -eq 1 ]; then
  echo "Dry run: would copy SKILL.md, references/, scripts/, and agents/."
  exit 0
fi

mkdir -p "$skill_home"
cp -a "$repo_root/SKILL.md" "$repo_root/references" "$repo_root/scripts" "$repo_root/agents" "$skill_home/"

echo "Installed Ask DongFeng to: $skill_home"

if command -v hermes >/dev/null 2>&1; then
  echo "Hermes detected. Verify with:"
  echo "  hermes skills list --source local --enabled-only | grep ask-dongfeng"
else
  echo "Hermes CLI was not found on PATH. Install Hermes, then run:"
  echo "  hermes skills list --source local --enabled-only | grep ask-dongfeng"
fi
